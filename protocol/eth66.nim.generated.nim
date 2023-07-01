
## Generated at line 65
type
  eth66* = object
template State*(PROTO: type eth66): type =
  ref[EthPeerState:ObjectType]

template NetworkState*(PROTO: type eth66): type =
  ref[EthWireBase:ObjectType]

type
  statusObj* = object
    ethVersionArg*: uint
    networkId*: NetworkId
    totalDifficulty*: DifficultyInt
    bestHash*: Hash256
    genesisHash*: Hash256
    forkId*: ChainForkId

template status*(PROTO: type eth66): type =
  statusObj

template msgProtocol*(MSG: type statusObj): type =
  eth66

template RecType*(MSG: type statusObj): untyped =
  statusObj

template msgId*(MSG: type statusObj): int =
  0

type
  newBlockHashesObj* = object
    hashes*: seq[NewBlockHashesAnnounce]

template newBlockHashes*(PROTO: type eth66): type =
  newBlockHashesObj

template msgProtocol*(MSG: type newBlockHashesObj): type =
  eth66

template RecType*(MSG: type newBlockHashesObj): untyped =
  newBlockHashesObj

template msgId*(MSG: type newBlockHashesObj): int =
  1

type
  transactionsObj* = object
    transactions*: seq[Transaction]

template transactions*(PROTO: type eth66): type =
  transactionsObj

template msgProtocol*(MSG: type transactionsObj): type =
  eth66

template RecType*(MSG: type transactionsObj): untyped =
  transactionsObj

template msgId*(MSG: type transactionsObj): int =
  2

type
  blockHeadersObj* = object
    headers*: seq[BlockHeader]

template blockHeaders*(PROTO: type eth66): type =
  blockHeadersObj

template msgProtocol*(MSG: type blockHeadersObj): type =
  eth66

template RecType*(MSG: type blockHeadersObj): untyped =
  blockHeadersObj

template msgId*(MSG: type blockHeadersObj): int =
  4

type
  getBlockHeadersObj* = object
    request*: BlocksRequest

template getBlockHeaders*(PROTO: type eth66): type =
  getBlockHeadersObj

template msgProtocol*(MSG: type getBlockHeadersObj): type =
  eth66

template RecType*(MSG: type getBlockHeadersObj): untyped =
  getBlockHeadersObj

template msgId*(MSG: type getBlockHeadersObj): int =
  3

type
  blockBodiesObj* = object
    blocks*: seq[BlockBody]

template blockBodies*(PROTO: type eth66): type =
  blockBodiesObj

template msgProtocol*(MSG: type blockBodiesObj): type =
  eth66

template RecType*(MSG: type blockBodiesObj): untyped =
  blockBodiesObj

template msgId*(MSG: type blockBodiesObj): int =
  6

type
  getBlockBodiesObj* = object
    hashes*: seq[Hash256]

template getBlockBodies*(PROTO: type eth66): type =
  getBlockBodiesObj

template msgProtocol*(MSG: type getBlockBodiesObj): type =
  eth66

template RecType*(MSG: type getBlockBodiesObj): untyped =
  getBlockBodiesObj

template msgId*(MSG: type getBlockBodiesObj): int =
  5

type
  newBlockObj* = object
    blk*: EthBlock
    totalDifficulty*: DifficultyInt

template newBlock*(PROTO: type eth66): type =
  newBlockObj

template msgProtocol*(MSG: type newBlockObj): type =
  eth66

template RecType*(MSG: type newBlockObj): untyped =
  newBlockObj

template msgId*(MSG: type newBlockObj): int =
  7

type
  newPooledTransactionHashesObj* = object
    txHashes*: seq[Hash256]

template newPooledTransactionHashes*(PROTO: type eth66): type =
  newPooledTransactionHashesObj

template msgProtocol*(MSG: type newPooledTransactionHashesObj): type =
  eth66

template RecType*(MSG: type newPooledTransactionHashesObj): untyped =
  newPooledTransactionHashesObj

template msgId*(MSG: type newPooledTransactionHashesObj): int =
  8

type
  pooledTransactionsObj* = object
    transactions*: seq[Transaction]

template pooledTransactions*(PROTO: type eth66): type =
  pooledTransactionsObj

template msgProtocol*(MSG: type pooledTransactionsObj): type =
  eth66

template RecType*(MSG: type pooledTransactionsObj): untyped =
  pooledTransactionsObj

template msgId*(MSG: type pooledTransactionsObj): int =
  10

type
  getPooledTransactionsObj* = object
    txHashes*: seq[Hash256]

template getPooledTransactions*(PROTO: type eth66): type =
  getPooledTransactionsObj

template msgProtocol*(MSG: type getPooledTransactionsObj): type =
  eth66

template RecType*(MSG: type getPooledTransactionsObj): untyped =
  getPooledTransactionsObj

template msgId*(MSG: type getPooledTransactionsObj): int =
  9

type
  getNodeDataObj* = object
    nodeHashes*: seq[Hash256]

template getNodeData*(PROTO: type eth66): type =
  getNodeDataObj

template msgProtocol*(MSG: type getNodeDataObj): type =
  eth66

template RecType*(MSG: type getNodeDataObj): untyped =
  getNodeDataObj

template msgId*(MSG: type getNodeDataObj): int =
  13

type
  nodeDataObj* = object
    data*: seq[Blob]

template nodeData*(PROTO: type eth66): type =
  nodeDataObj

template msgProtocol*(MSG: type nodeDataObj): type =
  eth66

template RecType*(MSG: type nodeDataObj): untyped =
  nodeDataObj

template msgId*(MSG: type nodeDataObj): int =
  14

type
  receiptsObj* = object
    receipts*: seq[seq[Receipt]]

template receipts*(PROTO: type eth66): type =
  receiptsObj

template msgProtocol*(MSG: type receiptsObj): type =
  eth66

template RecType*(MSG: type receiptsObj): untyped =
  receiptsObj

template msgId*(MSG: type receiptsObj): int =
  16

type
  getReceiptsObj* = object
    hashes*: seq[Hash256]

template getReceipts*(PROTO: type eth66): type =
  getReceiptsObj

template msgProtocol*(MSG: type getReceiptsObj): type =
  eth66

template RecType*(MSG: type getReceiptsObj): untyped =
  getReceiptsObj

template msgId*(MSG: type getReceiptsObj): int =
  15

var eth66ProtocolObj = initProtocol("eth", 66, createPeerState[Peer,
    ref[EthPeerState:ObjectType]], createNetworkState[EthereumNode,
    ref[EthWireBase:ObjectType]])
var eth66Protocol = addr eth66ProtocolObj
template protocolInfo*(PROTO: type eth66): auto =
  eth66Protocol

proc statusRawSender(peerOrResponder: Peer; ethVersionArg: uint;
                     networkId: NetworkId; totalDifficulty: DifficultyInt;
                     bestHash: Hash256; genesisHash: Hash256;
                     forkId: ChainForkId;
                     timeout: Duration = milliseconds(10000'i64)): Future[void] {.
    gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 0
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 0)
  append(writer, perPeerMsgId)
  startList(writer, 6)
  append(writer, ethVersionArg)
  append(writer, networkId)
  append(writer, totalDifficulty)
  append(writer, bestHash)
  append(writer, genesisHash)
  append(writer, forkId)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template status*(peer: Peer; ethVersionArg: uint; networkId: NetworkId;
                 totalDifficulty: DifficultyInt; bestHash: Hash256;
                 genesisHash: Hash256; forkId: ChainForkId;
                 timeout: Duration = milliseconds(10000'i64)): Future[statusObj] =
  let peer_5452595291 = peer
  let sendingFuture`gensym61 = statusRawSender(peer, ethVersionArg, networkId,
      totalDifficulty, bestHash, genesisHash, forkId)
  handshakeImpl(peer_5452595291, sendingFuture`gensym61,
                nextMsg(peer_5452595291, statusObj), timeout)

proc newBlockHashes*(peerOrResponder: Peer;
                     hashes: openArray[NewBlockHashesAnnounce]): Future[void] {.
    gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 1
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 1)
  append(writer, perPeerMsgId)
  append(writer, hashes)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

proc transactions*(peerOrResponder: Peer; transactions: openArray[Transaction]): Future[
    void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 2
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 2)
  append(writer, perPeerMsgId)
  append(writer, transactions)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

proc blockHeaders*(peerOrResponder: ResponderWithId[blockHeadersObj];
                   headers: openArray[BlockHeader]): Future[void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 4
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 4)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  append(writer, peerOrResponder.reqId)
  append(writer, headers)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym77: ResponderWithId[blockHeadersObj];
               args`gensym77: varargs[untyped]): auto =
  blockHeaders(r`gensym77, args`gensym77)

proc getBlockHeaders*(peerOrResponder: Peer; request: BlocksRequest;
                      timeout: Duration = milliseconds(10000'i64)): Future[
    Option[blockHeadersObj]] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 3
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 3)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, request)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc blockBodies*(peerOrResponder: ResponderWithId[blockBodiesObj];
                  blocks: openArray[BlockBody]): Future[void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 6
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 6)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  append(writer, peerOrResponder.reqId)
  append(writer, blocks)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym94: ResponderWithId[blockBodiesObj];
               args`gensym94: varargs[untyped]): auto =
  blockBodies(r`gensym94, args`gensym94)

proc getBlockBodies*(peerOrResponder: Peer; hashes: openArray[Hash256];
                     timeout: Duration = milliseconds(10000'i64)): Future[
    Option[blockBodiesObj]] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 5
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 5)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, hashes)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc newBlock*(peerOrResponder: Peer; blk: EthBlock;
               totalDifficulty: DifficultyInt): Future[void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 7
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 7)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  append(writer, blk)
  append(writer, totalDifficulty)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

proc newPooledTransactionHashes*(peerOrResponder: Peer;
                                 txHashes: openArray[Hash256]): Future[void] {.
    gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 8
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 8)
  append(writer, perPeerMsgId)
  append(writer, txHashes)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

proc pooledTransactions*(peerOrResponder: ResponderWithId[pooledTransactionsObj];
                         transactions: openArray[Transaction]): Future[void] {.
    gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 10
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 10)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  append(writer, peerOrResponder.reqId)
  append(writer, transactions)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym124: ResponderWithId[pooledTransactionsObj];
               args`gensym124: varargs[untyped]): auto =
  pooledTransactions(r`gensym124, args`gensym124)

proc getPooledTransactions*(peerOrResponder: Peer; txHashes: openArray[Hash256];
                            timeout: Duration = milliseconds(10000'i64)): Future[
    Option[pooledTransactionsObj]] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 9
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 9)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, txHashes)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc getNodeData*(peerOrResponder: Peer; nodeHashes: openArray[Hash256]): Future[
    void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 13
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 13)
  append(writer, perPeerMsgId)
  append(writer, nodeHashes)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

proc nodeData*(peerOrResponder: Peer; data: openArray[Blob]): Future[void] {.
    gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 14
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 14)
  append(writer, perPeerMsgId)
  append(writer, data)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

proc receipts*(peerOrResponder: ResponderWithId[receiptsObj];
               receipts: openArray[seq[Receipt]]): Future[void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 16
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 16)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  append(writer, peerOrResponder.reqId)
  append(writer, receipts)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym153: ResponderWithId[receiptsObj];
               args`gensym153: varargs[untyped]): auto =
  receipts(r`gensym153, args`gensym153)

proc getReceipts*(peerOrResponder: Peer; hashes: openArray[Hash256];
                  timeout: Duration = milliseconds(10000'i64)): Future[
    Option[receiptsObj]] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 15
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 15)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, hashes)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc statusUserHandler(peer: Peer; ethVersionArg: uint; networkId: NetworkId;
                       totalDifficulty: DifficultyInt; bestHash: Hash256;
                       genesisHash: Hash256; forkId: ChainForkId) {.gcsafe,
    async.} =
  type
    CurrentProtocol = eth66
  const
    perProtocolMsgId = 0
  template state(peer: Peer): ref[EthPeerState:ObjectType] =
    cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

  template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
    cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
        eth66Protocol))

  info trEthRecvReceived & "Status (0x00)", peer, networkId, totalDifficulty,
       bestHash = short(bestHash), genesisHash = short(genesisHash),
       forkHash = forkId.forkHash.toHex, forkNext = forkId.forkNext

proc newBlockHashesUserHandler(peer: Peer; hashes: seq[NewBlockHashesAnnounce]) {.
    gcsafe, async.} =
  type
    CurrentProtocol = eth66
  const
    perProtocolMsgId = 1
  template state(peer: Peer): ref[EthPeerState:ObjectType] =
    cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

  template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
    cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
        eth66Protocol))

  when trEthTraceGossipOk:
    info trEthRecvReceived & "NewBlockHashes (0x01)", peer, hashes = hashes.len
  let ctx = peer.networkState()
  ctx.handleNewBlockHashes(peer, hashes)

proc transactionsUserHandler(peer: Peer; transactions: seq[Transaction]) {.
    gcsafe, async.} =
  type
    CurrentProtocol = eth66
  const
    perProtocolMsgId = 2
  template state(peer: Peer): ref[EthPeerState:ObjectType] =
    cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

  template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
    cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
        eth66Protocol))

  when trEthTraceGossipOk:
    info trEthRecvReceived & "Transactions (0x02)", peer,
         transactions = transactions.len
  let ctx = peer.networkState()
  ctx.handleAnnouncedTxs(peer, transactions)

proc getBlockHeadersUserHandler(peer: Peer; reqId: int; request: BlocksRequest) {.
    gcsafe, async.} =
  type
    CurrentProtocol = eth66
  const
    perProtocolMsgId = 3
  template state(peer: Peer): ref[EthPeerState:ObjectType] =
    cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

  template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
    cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
        eth66Protocol))

  var response = init(ResponderWithId[blockHeadersObj], peer, reqId)
  when trEthTracePacketsOk:
    info trEthRecvReceived & "GetBlockHeaders (0x03)", peer,
         count = request.maxResults
  if request.maxResults > uint64(maxHeadersFetch):
    debug "GetBlockHeaders (0x03) requested too many headers", peer,
          requested = request.maxResults, max = maxHeadersFetch
    await peer.disconnect(BreachOfProtocol)
    return
  let ctx = peer.networkState()
  let headers = ctx.getBlockHeaders(request)
  if headers.len > 0:
    info trEthSendReplying & "with BlockHeaders (0x04)", peer,
         sent = headers.len, requested = request.maxResults
  else:
    info trEthSendReplying & "EMPTY BlockHeaders (0x04)", peer, sent = 0,
         requested = request.maxResults
  await response.send(headers)

proc getBlockBodiesUserHandler(peer: Peer; reqId: int; hashes: seq[Hash256]) {.
    gcsafe, async.} =
  type
    CurrentProtocol = eth66
  const
    perProtocolMsgId = 5
  template state(peer: Peer): ref[EthPeerState:ObjectType] =
    cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

  template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
    cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
        eth66Protocol))

  var response = init(ResponderWithId[blockBodiesObj], peer, reqId)
  info trEthRecvReceived & "GetBlockBodies (0x05)", peer, hashes = hashes.len
  if hashes.len > maxBodiesFetch:
    debug "GetBlockBodies (0x05) requested too many bodies", peer,
          requested = hashes.len, max = maxBodiesFetch
    await peer.disconnect(BreachOfProtocol)
    return
  let ctx = peer.networkState()
  let bodies = ctx.getBlockBodies(hashes)
  if bodies.len > 0:
    info trEthSendReplying & "with BlockBodies (0x06)", peer, sent = bodies.len,
         requested = hashes.len
  else:
    info trEthSendReplying & "EMPTY BlockBodies (0x06)", peer, sent = 0,
         requested = hashes.len
  await response.send(bodies)

proc newBlockUserHandler(peer: Peer; blk: EthBlock;
                         totalDifficulty: DifficultyInt) {.gcsafe, async.} =
  type
    CurrentProtocol = eth66
  const
    perProtocolMsgId = 7
  template state(peer: Peer): ref[EthPeerState:ObjectType] =
    cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

  template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
    cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
        eth66Protocol))

  when trEthTraceGossipOk:
    info trEthRecvReceived & "NewBlock (0x07)", peer, totalDifficulty,
         blockNumber = blk.header.blockNumber,
         blockDifficulty = blk.header.difficulty
  let ctx = peer.networkState()
  ctx.handleNewBlock(peer, blk, totalDifficulty)

proc newPooledTransactionHashesUserHandler(peer: Peer; txHashes: seq[Hash256]) {.
    gcsafe, async.} =
  type
    CurrentProtocol = eth66
  const
    perProtocolMsgId = 8
  template state(peer: Peer): ref[EthPeerState:ObjectType] =
    cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

  template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
    cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
        eth66Protocol))

  when trEthTraceGossipOk:
    info trEthRecvReceived & "NewPooledTransactionHashes (0x08)", peer,
         hashes = txHashes.len
  let ctx = peer.networkState()
  ctx.handleAnnouncedTxsHashes(peer, txHashes)

proc getPooledTransactionsUserHandler(peer: Peer; reqId: int;
                                      txHashes: seq[Hash256]) {.gcsafe, async.} =
  type
    CurrentProtocol = eth66
  const
    perProtocolMsgId = 9
  template state(peer: Peer): ref[EthPeerState:ObjectType] =
    cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

  template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
    cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
        eth66Protocol))

  var response = init(ResponderWithId[pooledTransactionsObj], peer, reqId)
  info trEthRecvReceived & "GetPooledTransactions (0x09)", peer,
       hashes = txHashes.len
  let ctx = peer.networkState()
  let txs = ctx.getPooledTxs(txHashes)
  if txs.len > 0:
    info trEthSendReplying & "with PooledTransactions (0x0a)", peer,
         sent = txs.len, requested = txHashes.len
  else:
    info trEthSendReplying & "EMPTY PooledTransactions (0x0a)", peer, sent = 0,
         requested = txHashes.len
  await response.send(txs)

proc getNodeDataUserHandler(peer: Peer; nodeHashes: seq[Hash256]) {.gcsafe,
    async.} =
  type
    CurrentProtocol = eth66
  const
    perProtocolMsgId = 13
  template state(peer: Peer): ref[EthPeerState:ObjectType] =
    cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

  template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
    cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
        eth66Protocol))

  info trEthRecvReceived & "GetNodeData (0x0d)", peer, hashes = nodeHashes.len
  let ctx = peer.networkState()
  let data = ctx.getStorageNodes(nodeHashes)
  info trEthSendReplying & "NodeData (0x0e)", peer, sent = data.len,
       requested = nodeHashes.len
  await peer.nodeData(data)

proc nodeDataUserHandler(peer: Peer; data: seq[Blob]) {.gcsafe, async.} =
  type
    CurrentProtocol = eth66
  const
    perProtocolMsgId = 14
  template state(peer: Peer): ref[EthPeerState:ObjectType] =
    cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

  template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
    cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
        eth66Protocol))

  info trEthRecvReceived & "NodeData (0x0e)", peer, bytes = data.len
  let ctx = peer.networkState()
  ctx.handleNodeData(peer, data)

proc getReceiptsUserHandler(peer: Peer; reqId: int; hashes: seq[Hash256]) {.
    gcsafe, async.} =
  type
    CurrentProtocol = eth66
  const
    perProtocolMsgId = 15
  template state(peer: Peer): ref[EthPeerState:ObjectType] =
    cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

  template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
    cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
        eth66Protocol))

  var response = init(ResponderWithId[receiptsObj], peer, reqId)
  info trEthRecvReceived & "GetReceipts (0x0f)", peer, hashes = hashes.len
  let ctx = peer.networkState()
  let rec = ctx.getReceipts(hashes)
  if rec.len > 0:
    info trEthSendReplying & "with Receipts (0x10)", peer, sent = rec.len,
         requested = hashes.len
  else:
    info trEthSendReplying & "EMPTY Receipts (0x10)", peer, sent = 0,
         requested = hashes.len
  await response.send(rec)

proc statusThunk(peer: Peer; _: int; data`gensym56: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym56
  var msg {.noinit.}: statusObj
  tryEnterList(rlp)
  msg.ethVersionArg = checkedRlpRead(peer, rlp, uint)
  msg.networkId = checkedRlpRead(peer, rlp, NetworkId)
  msg.totalDifficulty = checkedRlpRead(peer, rlp, DifficultyInt)
  msg.bestHash = checkedRlpRead(peer, rlp, Hash256)
  msg.genesisHash = checkedRlpRead(peer, rlp, Hash256)
  msg.forkId = checkedRlpRead(peer, rlp, ChainForkId)
  await(statusUserHandler(peer, msg.ethVersionArg, msg.networkId,
                          msg.totalDifficulty, msg.bestHash, msg.genesisHash,
                          msg.forkId))
  
proc newBlockHashesThunk(peer: Peer; _: int; data`gensym63: Rlp) {.async,
    gcsafe, raises: [RlpError].} =
  var rlp = data`gensym63
  var msg {.noinit.}: newBlockHashesObj
  msg.hashes = checkedRlpRead(peer, rlp, openArray[NewBlockHashesAnnounce])
  await(newBlockHashesUserHandler(peer, msg.hashes))
  
proc transactionsThunk(peer: Peer; _: int; data`gensym69: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym69
  var msg {.noinit.}: transactionsObj
  msg.transactions = checkedRlpRead(peer, rlp, openArray[Transaction])
  await(transactionsUserHandler(peer, msg.transactions))
  
proc blockHeadersThunk(peer: Peer; _: int; data`gensym76: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym76
  var msg {.noinit.}: blockHeadersObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.headers = checkedRlpRead(peer, rlp, openArray[BlockHeader])
  resolveResponseFuture(peer, perPeerMsgId(peer, blockHeadersObj), addr(msg),
                        reqId)

proc getBlockHeadersThunk(peer: Peer; _: int; data`gensym86: Rlp) {.async,
    gcsafe, raises: [RlpError].} =
  var rlp = data`gensym86
  var msg {.noinit.}: getBlockHeadersObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.request = checkedRlpRead(peer, rlp, BlocksRequest)
  await(getBlockHeadersUserHandler(peer, reqId, msg.request))
  
proc blockBodiesThunk(peer: Peer; _: int; data`gensym93: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym93
  var msg {.noinit.}: blockBodiesObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.blocks = checkedRlpRead(peer, rlp, openArray[BlockBody])
  resolveResponseFuture(peer, perPeerMsgId(peer, blockBodiesObj), addr(msg),
                        reqId)

proc getBlockBodiesThunk(peer: Peer; _: int; data`gensym103: Rlp) {.async,
    gcsafe, raises: [RlpError].} =
  var rlp = data`gensym103
  var msg {.noinit.}: getBlockBodiesObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.hashes = checkedRlpRead(peer, rlp, openArray[Hash256])
  await(getBlockBodiesUserHandler(peer, reqId, msg.hashes))
  
proc newBlockThunk(peer: Peer; _: int; data`gensym110: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym110
  var msg {.noinit.}: newBlockObj
  tryEnterList(rlp)
  msg.blk = checkedRlpRead(peer, rlp, EthBlock)
  msg.totalDifficulty = checkedRlpRead(peer, rlp, DifficultyInt)
  await(newBlockUserHandler(peer, msg.blk, msg.totalDifficulty))
  
proc newPooledTransactionHashesThunk(peer: Peer; _: int; data`gensym116: Rlp) {.
    async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym116
  var msg {.noinit.}: newPooledTransactionHashesObj
  msg.txHashes = checkedRlpRead(peer, rlp, openArray[Hash256])
  await(newPooledTransactionHashesUserHandler(peer, msg.txHashes))
  
proc pooledTransactionsThunk(peer: Peer; _: int; data`gensym123: Rlp) {.async,
    gcsafe, raises: [RlpError].} =
  var rlp = data`gensym123
  var msg {.noinit.}: pooledTransactionsObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.transactions = checkedRlpRead(peer, rlp, openArray[Transaction])
  resolveResponseFuture(peer, perPeerMsgId(peer, pooledTransactionsObj),
                        addr(msg), reqId)

proc getPooledTransactionsThunk(peer: Peer; _: int; data`gensym133: Rlp) {.
    async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym133
  var msg {.noinit.}: getPooledTransactionsObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.txHashes = checkedRlpRead(peer, rlp, openArray[Hash256])
  await(getPooledTransactionsUserHandler(peer, reqId, msg.txHashes))
  
proc getNodeDataThunk(peer: Peer; _: int; data`gensym139: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym139
  var msg {.noinit.}: getNodeDataObj
  msg.nodeHashes = checkedRlpRead(peer, rlp, openArray[Hash256])
  await(getNodeDataUserHandler(peer, msg.nodeHashes))
  
proc nodeDataThunk(peer: Peer; _: int; data`gensym145: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym145
  var msg {.noinit.}: nodeDataObj
  msg.data = checkedRlpRead(peer, rlp, openArray[Blob])
  await(nodeDataUserHandler(peer, msg.data))
  
proc receiptsThunk(peer: Peer; _: int; data`gensym152: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym152
  var msg {.noinit.}: receiptsObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.receipts = checkedRlpRead(peer, rlp, openArray[seq[Receipt]])
  resolveResponseFuture(peer, perPeerMsgId(peer, receiptsObj), addr(msg), reqId)

proc getReceiptsThunk(peer: Peer; _: int; data`gensym162: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym162
  var msg {.noinit.}: getReceiptsObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.hashes = checkedRlpRead(peer, rlp, openArray[Hash256])
  await(getReceiptsUserHandler(peer, reqId, msg.hashes))
  
registerMsg(eth66Protocol, 0, "status", statusThunk, messagePrinter[statusObj],
            requestResolver[statusObj], nextMsgResolver[statusObj])
registerMsg(eth66Protocol, 1, "newBlockHashes", newBlockHashesThunk,
            messagePrinter[newBlockHashesObj],
            requestResolver[newBlockHashesObj],
            nextMsgResolver[newBlockHashesObj])
registerMsg(eth66Protocol, 2, "transactions", transactionsThunk,
            messagePrinter[transactionsObj], requestResolver[transactionsObj],
            nextMsgResolver[transactionsObj])
registerMsg(eth66Protocol, 4, "blockHeaders", blockHeadersThunk,
            messagePrinter[blockHeadersObj], requestResolver[blockHeadersObj],
            nextMsgResolver[blockHeadersObj])
registerMsg(eth66Protocol, 3, "getBlockHeaders", getBlockHeadersThunk,
            messagePrinter[getBlockHeadersObj],
            requestResolver[getBlockHeadersObj],
            nextMsgResolver[getBlockHeadersObj])
registerMsg(eth66Protocol, 6, "blockBodies", blockBodiesThunk,
            messagePrinter[blockBodiesObj], requestResolver[blockBodiesObj],
            nextMsgResolver[blockBodiesObj])
registerMsg(eth66Protocol, 5, "getBlockBodies", getBlockBodiesThunk,
            messagePrinter[getBlockBodiesObj],
            requestResolver[getBlockBodiesObj],
            nextMsgResolver[getBlockBodiesObj])
registerMsg(eth66Protocol, 7, "newBlock", newBlockThunk,
            messagePrinter[newBlockObj], requestResolver[newBlockObj],
            nextMsgResolver[newBlockObj])
registerMsg(eth66Protocol, 8, "newPooledTransactionHashes",
            newPooledTransactionHashesThunk,
            messagePrinter[newPooledTransactionHashesObj],
            requestResolver[newPooledTransactionHashesObj],
            nextMsgResolver[newPooledTransactionHashesObj])
registerMsg(eth66Protocol, 10, "pooledTransactions", pooledTransactionsThunk,
            messagePrinter[pooledTransactionsObj],
            requestResolver[pooledTransactionsObj],
            nextMsgResolver[pooledTransactionsObj])
registerMsg(eth66Protocol, 9, "getPooledTransactions",
            getPooledTransactionsThunk,
            messagePrinter[getPooledTransactionsObj],
            requestResolver[getPooledTransactionsObj],
            nextMsgResolver[getPooledTransactionsObj])
registerMsg(eth66Protocol, 13, "getNodeData", getNodeDataThunk,
            messagePrinter[getNodeDataObj], requestResolver[getNodeDataObj],
            nextMsgResolver[getNodeDataObj])
registerMsg(eth66Protocol, 14, "nodeData", nodeDataThunk,
            messagePrinter[nodeDataObj], requestResolver[nodeDataObj],
            nextMsgResolver[nodeDataObj])
registerMsg(eth66Protocol, 16, "receipts", receiptsThunk,
            messagePrinter[receiptsObj], requestResolver[receiptsObj],
            nextMsgResolver[receiptsObj])
registerMsg(eth66Protocol, 15, "getReceipts", getReceiptsThunk,
            messagePrinter[getReceiptsObj], requestResolver[getReceiptsObj],
            nextMsgResolver[getReceiptsObj])
proc eth66PeerConnected(peer: Peer) {.gcsafe, async.} =
  type
    CurrentProtocol = eth66
  template state(peer: Peer): ref[EthPeerState:ObjectType] =
    cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

  template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
    cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
        eth66Protocol))

  let
    network = peer.network
    ctx = peer.networkState
    status = ctx.getStatus()
  info trEthSendSending & "Status (0x00)", peer, td = status.totalDifficulty,
       bestHash = short(status.bestBlockHash), networkId = network.networkId,
       genesis = short(status.genesisHash), forkHash = status.forkId.forkHash,
       forkNext = status.forkId.forkNext
  let m = await peer.status(ethVersion, network.networkId,
                            status.totalDifficulty, status.bestBlockHash,
                            status.genesisHash, status.forkId,
                            timeout = chronos.seconds(10))
  when trEthTraceHandshakesOk:
    info "Handshake: Local and remote networkId", local = network.networkId,
         remote = m.networkId
    info "Handshake: Local and remote genesisHash", local = status.genesisHash,
         remote = m.genesisHash
    info "Handshake: Local and remote forkId", local = (
        status.forkId.forkHash.toHex & "/" & $status.forkId.forkNext),
         remote = (m.forkId.forkHash.toHex & "/" & $m.forkId.forkNext)
  if m.networkId != network.networkId:
    info "Peer for a different network (networkId)", peer,
         expectNetworkId = network.networkId, gotNetworkId = m.networkId
    raise newException(UselessPeerError, "Eth handshake for different network")
  if m.genesisHash != status.genesisHash:
    info "Peer for a different network (genesisHash)", peer,
         expectGenesis = short(status.genesisHash),
         gotGenesis = short(m.genesisHash)
  info "Peer matches our network", peer
  peer.state.initialized = true
  peer.state.bestDifficulty = m.totalDifficulty
  peer.state.bestBlockHash = m.bestHash

setEventHandlers(eth66Protocol, eth66PeerConnected, nil)
registerProtocol(eth66Protocol)