{.push raises: [].}

import
  std/[tables, times, hashes, sets, sequtils, typetraits, json],
  chronicles, 
  chronos,
  eth/p2p,
  eth/p2p/peer_pool,
  stew/byteutils,
  ".."/[types, protocol],
  ../protocol/eth/eth_types,
  ../protocol/trace_config, 
  ../../core/[chain, tx_pool, tx_pool/tx_item, tx_pool/tx_desc, tx_pool/tx_tasks/tx_dispose, tx_pool/tx_tasks/tx_add, tx_pool/tx_tabs],
  ../../core/executor/[process_transaction, process_block],
  ../../evm/[types,state],
  ../../db/[storage_types,accounts_cache, state_db, incomplete_db, distinct_tries],
  ../../evm/async/data_sources/json_rpc_data_source,
  ../../stateless_runner,
  ../../transaction/call_evm,
  ../../rpc/rpc_utils,
  ../../transaction,
  ../../tracer

logScope:
  topics = "eth-wire"

type
  HashToTime = TableRef[Hash256, Time]

  NewBlockHandler* = proc(
    arg: pointer,
    peer: Peer,
    blk: EthBlock,
    totalDifficulty: DifficultyInt) {.
      gcsafe, raises: [CatchableError].}

  NewBlockHashesHandler* = proc(
    arg: pointer,
    peer: Peer,
    hashes: openArray[NewBlockHashesAnnounce]) {.
      gcsafe, raises: [CatchableError].}

  NewBlockHandlerPair = object
    arg: pointer
    handler: NewBlockHandler

  NewBlockHashesHandlerPair = object
    arg: pointer
    handler: NewBlockHashesHandler

  EthWireRunState = enum
    Enabled
    Suspended
    NotAvailable

  EthWireRef* = ref object of EthWireBase
    db*: ChainDBRef
    chain*: ChainRef
    txPool*: TxPoolRef
    peerPool*: PeerPool
    enableTxPool: EthWireRunState
    knownByPeer: Table[Peer, HashToTime]
    pending: HashSet[Hash256]
    lastCleanup: Time
    newBlockHandler: NewBlockHandlerPair
    newBlockHashesHandler: NewBlockHashesHandlerPair

  ReconnectRef = ref object
    pool: PeerPool
    node: Node

const
  NUM_PEERS_REBROADCAST_QUOTIENT = 4
  POOLED_STORAGE_TIME_LIMIT = initDuration(minutes = 20)
  PEER_LONG_BANTIME = chronos.minutes(150)


proc notEnabled(name: string) {.used.} =
  debug "Wire handler method is disabled", meth = name

proc notImplemented(name: string) {.used.} =
  debug "Wire handler method not implemented", meth = name

proc inPool(ctx: EthWireRef, txHash: Hash256): bool =
  let res = ctx.txPool.getItem(txHash)
  res.isOk

proc inPoolAndOk(ctx: EthWireRef, txHash: Hash256): bool =
  let res = ctx.txPool.getItem(txHash)
  if res.isErr: return false
  res.get().reject == txInfoOk

proc successorHeader(db: ChainDBRef,
                     h: BlockHeader,
                     output: var BlockHeader,
                     skip = 0'u): bool {.gcsafe, raises: [RlpError].} =
  let offset = 1 + skip.toBlockNumber
  if h.blockNumber <= (not 0.toBlockNumber) - offset:
    result = db.getBlockHeader(h.blockNumber + offset, output)

proc ancestorHeader(db: ChainDBRef,
                     h: BlockHeader,
                     output: var BlockHeader,
                     skip = 0'u): bool {.gcsafe, raises: [RlpError].} =
  let offset = 1 + skip.toBlockNumber
  if h.blockNumber >= offset:
    result = db.getBlockHeader(h.blockNumber - offset, output)

proc blockHeader(db: ChainDBRef,
                 b: HashOrNum,
                 output: var BlockHeader): bool
                 {.gcsafe, raises: [RlpError].} =
  if b.isHash:
    db.getBlockHeader(b.hash, output)
  else:
    db.getBlockHeader(b.number, output)

# ------------------------------------------------------------------------------
# Private functions: peers related functions
# ------------------------------------------------------------------------------

proc hash(peer: Peer): hashes.Hash {.used.} =
  hash(peer.remote)

proc getPeers(ctx: EthWireRef, thisPeer: Peer): seq[Peer] =
  # do not send back tx or txhash to thisPeer
  for peer in peers(ctx.peerPool):
    if peer != thisPeer:
      result.add peer

proc banExpiredReconnect(arg: pointer) =
  # Reconnect to peer after ban period if pool is empty
  try:

    let reconnect = cast[ReconnectRef](arg)
    if reconnect.pool.len > 0:
      return

    asyncSpawn reconnect.pool.connectToNode(reconnect.node)

  except TransportError:
    debug "Transport got closed during banExpiredReconnect"
  except CatchableError as e:
    debug "Exception in banExpiredReconnect", exc = e.name, err = e.msg

proc banPeer(pool: PeerPool, peer: Peer, banTime: chronos.Duration) {.async.} =
  try:

    await peer.disconnect(SubprotocolReason)

    let expired = Moment.fromNow(banTime)
    let reconnect = ReconnectRef(
      pool: pool,
      node: peer.remote
    )

    discard setTimer(
      expired,
      banExpiredReconnect,
      cast[pointer](reconnect)
    )

  except TransportError:
    debug "Transport got closed during banPeer"
  except CatchableError as e:
    debug "Exception in banPeer", exc = e.name, err = e.msg

proc cleanupKnownByPeer(ctx: EthWireRef) =
  let now = getTime()
  var tmp = initHashSet[Hash256]()
  for _, map in ctx.knownByPeer:
    for hash, time in map:
      if time - now >= POOLED_STORAGE_TIME_LIMIT:
        tmp.incl hash
    for hash in tmp:
      map.del(hash)
    tmp.clear()

  var tmpPeer = initHashSet[Peer]()
  for peer, map in ctx.knownByPeer:
    if map.len == 0:
      tmpPeer.incl peer

  for peer in tmpPeer:
    ctx.knownByPeer.del peer

  ctx.lastCleanup = now

proc addToKnownByPeer(ctx: EthWireRef, txHashes: openArray[Hash256], peer: Peer) =
  var map: HashToTime
  ctx.knownByPeer.withValue(peer, val) do:
    map = val[]
  do:
    map = newTable[Hash256, Time]()
    ctx.knownByPeer[peer] = map

  for txHash in txHashes:
    if txHash notin map:
      map[txHash] = getTime()

proc addToKnownByPeer(ctx: EthWireRef,
                      txHashes: openArray[Hash256],
                      peer: Peer,
                      newHashes: var seq[Hash256]) =
  var map: HashToTime
  ctx.knownByPeer.withValue(peer, val) do:
    map = val[]
  do:
    map = newTable[Hash256, Time]()
    ctx.knownByPeer[peer] = map

  newHashes = newSeqOfCap[Hash256](txHashes.len)
  for txHash in txHashes:
    if txHash notin map:
      map[txHash] = getTime()
      newHashes.add txHash

# ------------------------------------------------------------------------------
# Private functions: async workers
# ------------------------------------------------------------------------------

proc sendNewTxHashes(ctx: EthWireRef,
                     txHashes: seq[Hash256],
                     peers: seq[Peer]): Future[void] {.async.} =
  try:

    for peer in peers:
      # Add to known tx hashes and get hashes still to send to peer
      var hashesToSend: seq[Hash256]
      ctx.addToKnownByPeer(txHashes, peer, hashesToSend)

      # Broadcast to peer if at least 1 new tx hash to announce
      if hashesToSend.len > 0:
        await peer.newPooledTransactionHashes(hashesToSend)

  except TransportError:
    debug "Transport got closed during sendNewTxHashes"
  except CatchableError as e:
    debug "Exception in sendNewTxHashes", exc = e.name, err = e.msg

proc sendTransactions(ctx: EthWireRef,
                      txHashes: seq[Hash256],
                      txs: seq[Transaction],
                      peers: seq[Peer]): Future[void] {.async.} =
  try:

    for peer in peers:
      # This is used to avoid re-sending along pooledTxHashes
      # announcements/re-broadcasts
      ctx.addToKnownByPeer(txHashes, peer)
      await peer.transactions(txs)

  except TransportError:
    debug "Transport got closed during sendTransactions"
  except CatchableError as e:
    debug "Exception in sendTransactions", exc = e.name, err = e.msg

proc fetchTransactions(ctx: EthWireRef, reqHashes: seq[Hash256], peer: Peer): Future[void] {.async.} =
  discard
  # info "fetchTx: requesting txs", number = reqHashes.len

  # try:

  #   let res = await peer.getPooledTransactions(reqHashes)
  #   if res.isNone:
  #     error "not able to get pooled transactions"
  #     return

  #   let txs = res.get()
  #   info "fetchTx: received requested txs", number = txs.transactions.len

  #   # Remove from pending list regardless if tx is in result
  #   for tx in txs.transactions:
  #     let txHash = rlpHash(tx)
  #     ctx.pending.excl txHash

  #   ctx.txPool.add(txs.transactions)

  # except TransportError:
  #   debug "Transport got closed during fetchTransactions"
  #   return
  # except CatchableError as e:
  #   debug "Exception in fetchTransactions", exc = e.name, err = e.msg
  #   return

  # var newTxHashes = newSeqOfCap[Hash256](reqHashes.len)
  # for txHash in reqHashes:
  #   if ctx.inPoolAndOk(txHash):
  #     newTxHashes.add txHash

  # let peers = ctx.getPeers(peer)
  # if peers.len == 0 or newTxHashes.len == 0:
  #   return

  # await ctx.sendNewTxHashes(newTxHashes, peers)

# ------------------------------------------------------------------------------
# Private functions: peer observer
# ------------------------------------------------------------------------------

proc onPeerConnected(ctx: EthWireRef, peer: Peer) =
  if ctx.enableTxPool != Enabled:
    when trMissingOrDisabledGossipOk:
      notEnabled("onPeerConnected")
    return

  var txHashes = newSeqOfCap[Hash256](ctx.txPool.numTxs)
  for txHash, item in okPairs(ctx.txPool):
    txHashes.add txHash

  if txHashes.len == 0:
    return

  debug "announce tx hashes to newly connected peer",
    number = txHashes.len

  asyncSpawn ctx.sendNewTxHashes(txHashes, @[peer])

proc onPeerDisconnected(ctx: EthWireRef, peer: Peer) =
  debug "remove peer from knownByPeer",
    peer

  ctx.knownByPeer.del(peer)

proc setupPeerObserver(ctx: EthWireRef) =
  var po = PeerObserver(
    onPeerConnected:
      proc(p: Peer) {.gcsafe.} =
        ctx.onPeerConnected(p),
    onPeerDisconnected:
      proc(p: Peer) {.gcsafe.} =
        ctx.onPeerDisconnected(p))
  po.setProtocol protocol.eth
  ctx.peerPool.addObserver(ctx, po)

# ------------------------------------------------------------------------------
# Public constructor/destructor
# ------------------------------------------------------------------------------

proc new*(_: type EthWireRef,
          chain: ChainRef,
          txPool: TxPoolRef,
          peerPool: PeerPool): EthWireRef =
  let ctx = EthWireRef(
    db: chain.db,
    chain: chain,
    txPool: txPool,
    peerPool: peerPool,
    enableTxPool: Enabled,
    lastCleanup: getTime())
  if txPool.isNil:
    ctx.enableTxPool = NotAvailable
    when trMissingOrDisabledGossipOk:
      trace "New eth handler, minimal/outbound support only"

  ctx.setupPeerObserver()
  ctx

# ------------------------------------------------------------------------------
# Public functions: callbacks setters
# ------------------------------------------------------------------------------

proc setNewBlockHandler*(ctx: EthWireRef, handler: NewBlockHandler, arg: pointer) =
  ctx.newBlockHandler = NewBlockHandlerPair(
    arg: arg,
    handler: handler
  )

proc setNewBlockHashesHandler*(ctx: EthWireRef, handler: NewBlockHashesHandler, arg: pointer) =
  ctx.newBlockHashesHandler = NewBlockHashesHandlerPair(
    arg: arg,
    handler: handler
  )

# ------------------------------------------------------------------------------
# Public getters/setters
# ------------------------------------------------------------------------------

proc `txPoolEnabled=`*(ctx: EthWireRef; ena: bool) {.gcsafe, raises: [].} =
  if ctx.enableTxPool != NotAvailable:
    ctx.enableTxPool = if ena: Enabled else: Suspended

proc txPoolEnabled*(ctx: EthWireRef): bool {.gcsafe, raises: [].} =
  ctx.enableTxPool == Enabled

# ------------------------------------------------------------------------------
# Public functions: eth wire protocol handlers
# ------------------------------------------------------------------------------

method getStatus*(ctx: EthWireRef): EthState {.gcsafe, raises: [RlpError,EVMError].} =
  info "EthWireRef getStatus"
  let
    db = ctx.db
    com = ctx.chain.com
    bestBlock = db.getCanonicalHead()
    forkId = com.forkId(bestBlock.forkDeterminationInfoForHeader)

  EthState(
    totalDifficulty: db.headTotalDifficulty,
    genesisHash: com.genesisHash,
    # genesisHash: Hash256.fromHex"0D21840ABFF46B96C84B2AC9E10E4F5CDAEB5693CB665DB62A2F3B02D2D57B5B",
    bestBlockHash: bestBlock.blockHash,
    forkId: ChainForkId(
      forkHash: [byte(41),149,197,42], #forkId.crc.toBytesBE,
      forkNext: 0.u256 #forkId.nextFork.toBlockNumber
    )
  )

method getReceipts*(ctx: EthWireRef, hashes: openArray[Hash256]): seq[seq[Receipt]] {.gcsafe, raises: [RlpError].} =
  let db = ctx.db
  var header: BlockHeader
  for blockHash in hashes:
    if db.getBlockHeader(blockHash, header):
      result.add db.getReceipts(header.receiptRoot)
    else:
      result.add @[]
      trace "handlers.getReceipts: blockHeader not found", blockHash

method getPooledTxs*(ctx: EthWireRef, hashes: openArray[Hash256]): seq[Transaction] =
  let txPool = ctx.txPool
  for txHash in hashes:
    let res = txPool.getItem(txHash)
    if res.isOk:
      result.add res.value.tx
    else:
      info "handlers.getPooledTxs: tx not found", txHash

method getBlockBodies*(ctx: EthWireRef, hashes: openArray[Hash256]): seq[BlockBody]
    {.gcsafe, raises: [RlpError].} =
  let db = ctx.db
  var body: BlockBody
  for blockHash in hashes:
    if db.getBlockBody(blockHash, body):
      result.add body
    else:
      result.add BlockBody()
      trace "handlers.getBlockBodies: blockBody not found", blockHash

method getBlockHeaders*(ctx: EthWireRef, req: BlocksRequest): seq[BlockHeader] {.gcsafe, raises: [RlpError].} =
  let db = ctx.db
  var foundBlock: BlockHeader
  result = newSeqOfCap[BlockHeader](req.maxResults)

  if db.blockHeader(req.startBlock, foundBlock):
    result.add foundBlock

    while uint64(result.len) < req.maxResults:
      if not req.reverse:
        if not db.successorHeader(foundBlock, foundBlock, req.skip):
          break
      else:
        if not db.ancestorHeader(foundBlock, foundBlock, req.skip):
          break
      result.add foundBlock

method handleAnnouncedTxs*(ctx: EthWireRef, peer: Peer, txs: openArray[Transaction]) {.gcsafe, raises: [CatchableError].} =
  info "handleAnnouncedTxs", peer=peer, txs=txs.len, txHashes = txs.mapIt(it.itemID())
  if ctx.enableTxPool != Enabled:
    when trMissingOrDisabledGossipOk:
      notEnabled("handleAnnouncedTxs")
    return

  if txs.len == 0:
    return

  try:
    let header = ctx.chain.currentBlock()
    # info "handleAnnouncedTxs", parentHash=header.parentHash, headerHash=header.blockHash, txs=txs.len
    var vmState = BaseVMState.new(header, ctx.chain.com)
    let fork = vmState.com.toEVMFork(header.forkDeterminationInfoForHeader)
    let accountDB = newAccountStateDB(ctx.db.db, header.stateRoot, ctx.chain.com.pruneTrie)
    var address = EthAddress.fromHex "0x37Eed34FEdB7f396F8Fcf1ceE9969b9b49317b40"
    var client = waitFor makeAnRpcClient("http://149.28.74.252:8545")
    # var now = now().toTime()
    # var sortedTx: seq[Transaction]
    # if now < ctx.txPool.startDate + 3.seconds:
      # ctx.txPool.addTxs txs
      # for (account,nonceList) in ctx.txPool.txDB.packingOrderAccounts(txItemPending):
      #   sortedTx.add toSeq(nonceList.incNonce).mapIt(it.tx)
    # else:
    for tx in txs:
      var sender = tx.getSender()
      let (acc, accProof, storageProofs) = waitFor fetchAccountAndSlots(client, sender, @[], header.blockNumber)

      var accBalance = acc.balance

      var balance1 = vmState.stateDB.getBalance(sender)
      let accTx = vmState.stateDB.beginSavepoint
      let gasBurned = tx.txCallEvm(sender, vmState, fork)
      
      vmState.stateDB.commit(accTx)
      var balance2 = vmState.stateDB.getBalance(sender)
      info "txCallEvm", txHash = tx.rlpHash, gasBurned=gasBurned, sender=sender, nonce=tx.nonce, gasPrice=tx.gasPrice, gasLimit=tx.gasLimit, accBalance=accBalance, balance1=balance1, balance2=balance2
      populateDbWithBranch(ctx.db.db, accProof)
      for index, storageProof in storageProofs:
        echo "index:", index
        let slot: UInt256 = storageProof.key
        let fetchedVal: UInt256 = storageProof.value
        let storageMptNodes: seq[seq[byte]] = storageProof.proof.mapIt(distinctBase(it))
        let storageVerificationRes = verifyFetchedSlot(acc.storageRoot, slot, fetchedVal, storageMptNodes)
        let whatAreWeVerifying = ("storage proof", sender, acc, slot, fetchedVal)
        raiseExceptionIfError(whatAreWeVerifying, storageVerificationRes)

        populateDbWithBranch(ctx.db.db, storageMptNodes)
        let slotAsKey = createTrieKeyFromSlot(slot)
        let slotHash = keccakHash(slotAsKey)
        let slotEncoded = rlp.encode(slot)
        ctx.db.db.put(slotHashToSlotKey(slotHash.data).toOpenArray, slotEncoded)
    
  except:
    echo getCurrentExceptionMsg()

  if ctx.lastCleanup - getTime() > POOLED_STORAGE_TIME_LIMIT:
    ctx.cleanupKnownByPeer()

  var txHashes = newSeqOfCap[Hash256](txs.len)
  for tx in txs:
    txHashes.add rlpHash(tx)

  ctx.addToKnownByPeer(txHashes, peer)
  ctx.txPool.add(txs)

  var newTxHashes = newSeqOfCap[Hash256](txHashes.len)
  var validTxs = newSeqOfCap[Transaction](txHashes.len)
  for i, txHash in txHashes:
    # Nodes must not automatically broadcast blob transactions to their peers. per EIP-4844 spec
    if ctx.inPoolAndOk(txHash) and txs[i].txType != TxEip4844:
      newTxHashes.add txHash
      validTxs.add txs[i]

  let
    peers = ctx.getPeers(peer)
    numPeers = peers.len
    sendFull = max(1, numPeers div NUM_PEERS_REBROADCAST_QUOTIENT)

  if numPeers == 0 or validTxs.len == 0:
    return

  asyncSpawn ctx.sendTransactions(txHashes, validTxs, peers[0..<sendFull])

  asyncSpawn ctx.sendNewTxHashes(newTxHashes, peers[sendFull..^1])

method handleAnnouncedTxsHashes*(ctx: EthWireRef, peer: Peer, txHashes: openArray[Hash256]) =
  if ctx.enableTxPool != Enabled:
    when trMissingOrDisabledGossipOk:
      notEnabled("handleAnnouncedTxsHashes")
    return

  if txHashes.len == 0:
    return

  if ctx.lastCleanup - getTime() > POOLED_STORAGE_TIME_LIMIT:
    ctx.cleanupKnownByPeer()

  ctx.addToKnownByPeer(txHashes, peer)
  var reqHashes = newSeqOfCap[Hash256](txHashes.len)
  for txHash in txHashes:
    if txHash in ctx.pending or ctx.inPool(txHash):
      continue
    reqHashes.add txHash

  if reqHashes.len == 0:
    return

  debug "handleAnnouncedTxsHashes: received new tx hashes", number = reqHashes.len

  for txHash in reqHashes:
    ctx.pending.incl txHash

  asyncSpawn ctx.fetchTransactions(reqHashes, peer)

method handleNewBlock*(ctx: EthWireRef, peer: Peer, blk: EthBlock, totalDifficulty: DifficultyInt) {.gcsafe, raises: [CatchableError].} =
  # if ctx.chain.com.forkGTE(MergeFork):
  #   debug "Dropping peer for sending NewBlock after merge (EIP-3675)",
  #     peer, blockNumber=blk.header.blockNumber,
  #     blockHash=blk.header.blockHash, totalDifficulty
  #   asyncSpawn banPeer(ctx.peerPool, peer, PEER_LONG_BANTIME)
  #   return
  let body = BlockBody(transactions: blk.txs, uncles: blk.uncles)
  var res = ctx.chain.persistBlocks([blk.header], [body])
  if res == ValidationResult.Error:
      error "handleNewBlock: persistBlocks error"
      return
  res = ctx.chain.setCanonical(blk.header)
  if res == ValidationResult.Error:
    error "setCanonical", err=res
    return
  info "handleNewBlock", peer=peer, blk=blk.header.blockNumber, totalDifficulty=totalDifficulty
  if not ctx.newBlockHandler.handler.isNil:
    ctx.newBlockHandler.handler(ctx.newBlockHandler.arg, peer, blk, totalDifficulty)

method handleNewBlockHashes*(ctx: EthWireRef, peer: Peer, hashes: openArray[NewBlockHashesAnnounce]) {.gcsafe, raises: [CatchableError].} =
  info "handleNewBlockHashes", peer=peer, hashes=hashes.mapIt(it.number)

  try:
    var hashKey = canonicalHeadHashKey()
    ctx.db.db.put(hashKey.toOpenArray, rlp.encode hashes[0].number)
  except:
    echo getCurrentExceptionMsg()
  if not ctx.newBlockHashesHandler.handler.isNil:
    ctx.newBlockHashesHandler.handler(ctx.newBlockHashesHandler.arg,peer,hashes)

when defined(legacy_eth66_enabled):
  method getStorageNodes*(ctx: EthWireRef, hashes: openArray[Hash256]): seq[Blob] {.gcsafe.} =
    let db = ctx.db.db
    for hash in hashes:
      result.add db.get(hash.data)

  method handleNodeData*(ctx: EthWireRef, peer: Peer, data: openArray[Blob]) {.gcsafe.} =
    notImplemented("handleNodeData")

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
