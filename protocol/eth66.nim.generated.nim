
## Generated at line 68
type
  eth66 = object
template State(PROTO: type eth66): type =
  ref[EthPeerState:ObjectType]

template NetworkState(PROTO: type eth66): type =
  ref[EthWireBase:ObjectType]

type
  statusObj = object
    ethVersionArg*: uint
    networkId*: NetworkId
    totalDifficulty*: DifficultyInt
    bestHash*: Hash256
    genesisHash*: Hash256
    forkId*: ChainForkId

template status(PROTO: type eth66): type =
  statusObj

template msgProtocol(MSG: type statusObj): type =
  eth66

template RecType(MSG: type statusObj): untyped =
  statusObj

template msgId(MSG: type statusObj): int =
  0

type
  newBlockHashesObj = object
    hashes*: seq[NewBlockHashesAnnounce]

template newBlockHashes(PROTO: type eth66): type =
  newBlockHashesObj

template msgProtocol(MSG: type newBlockHashesObj): type =
  eth66

template RecType(MSG: type newBlockHashesObj): untyped =
  newBlockHashesObj

template msgId(MSG: type newBlockHashesObj): int =
  1

type
  transactionsObj = object
    transactions*: seq[Transaction]

template transactions(PROTO: type eth66): type =
  transactionsObj

template msgProtocol(MSG: type transactionsObj): type =
  eth66

template RecType(MSG: type transactionsObj): untyped =
  transactionsObj

template msgId(MSG: type transactionsObj): int =
  2

type
  blockHeadersObj = object
    headers*: seq[BlockHeader]

template blockHeaders(PROTO: type eth66): type =
  blockHeadersObj

template msgProtocol(MSG: type blockHeadersObj): type =
  eth66

template RecType(MSG: type blockHeadersObj): untyped =
  blockHeadersObj

template msgId(MSG: type blockHeadersObj): int =
  4

type
  getBlockHeadersObj = object
    request*: BlocksRequest

template getBlockHeaders(PROTO: type eth66): type =
  getBlockHeadersObj

template msgProtocol(MSG: type getBlockHeadersObj): type =
  eth66

template RecType(MSG: type getBlockHeadersObj): untyped =
  getBlockHeadersObj

template msgId(MSG: type getBlockHeadersObj): int =
  3

type
  blockBodiesObj = object
    blocks*: seq[BlockBody]

template blockBodies(PROTO: type eth66): type =
  blockBodiesObj

template msgProtocol(MSG: type blockBodiesObj): type =
  eth66

template RecType(MSG: type blockBodiesObj): untyped =
  blockBodiesObj

template msgId(MSG: type blockBodiesObj): int =
  6

type
  getBlockBodiesObj = object
    hashes*: seq[Hash256]

template getBlockBodies(PROTO: type eth66): type =
  getBlockBodiesObj

template msgProtocol(MSG: type getBlockBodiesObj): type =
  eth66

template RecType(MSG: type getBlockBodiesObj): untyped =
  getBlockBodiesObj

template msgId(MSG: type getBlockBodiesObj): int =
  5

type
  newBlockObj = object
    blk*: EthBlock
    totalDifficulty*: DifficultyInt

template newBlock(PROTO: type eth66): type =
  newBlockObj

template msgProtocol(MSG: type newBlockObj): type =
  eth66

template RecType(MSG: type newBlockObj): untyped =
  newBlockObj

template msgId(MSG: type newBlockObj): int =
  7

type
  newPooledTransactionHashesObj = object
    txHashes*: seq[Hash256]

template newPooledTransactionHashes(PROTO: type eth66): type =
  newPooledTransactionHashesObj

template msgProtocol(MSG: type newPooledTransactionHashesObj): type =
  eth66

template RecType(MSG: type newPooledTransactionHashesObj): untyped =
  newPooledTransactionHashesObj

template msgId(MSG: type newPooledTransactionHashesObj): int =
  8

type
  pooledTransactionsObj = object
    transactions*: seq[Transaction]

template pooledTransactions(PROTO: type eth66): type =
  pooledTransactionsObj

template msgProtocol(MSG: type pooledTransactionsObj): type =
  eth66

template RecType(MSG: type pooledTransactionsObj): untyped =
  pooledTransactionsObj

template msgId(MSG: type pooledTransactionsObj): int =
  10

type
  getPooledTransactionsObj = object
    txHashes*: seq[Hash256]

template getPooledTransactions(PROTO: type eth66): type =
  getPooledTransactionsObj

template msgProtocol(MSG: type getPooledTransactionsObj): type =
  eth66

template RecType(MSG: type getPooledTransactionsObj): untyped =
  getPooledTransactionsObj

template msgId(MSG: type getPooledTransactionsObj): int =
  9

type
  getNodeDataObj = object
    nodeHashes*: seq[Hash256]

template getNodeData(PROTO: type eth66): type =
  getNodeDataObj

template msgProtocol(MSG: type getNodeDataObj): type =
  eth66

template RecType(MSG: type getNodeDataObj): untyped =
  getNodeDataObj

template msgId(MSG: type getNodeDataObj): int =
  13

type
  nodeDataObj = object
    data*: seq[Blob]

template nodeData(PROTO: type eth66): type =
  nodeDataObj

template msgProtocol(MSG: type nodeDataObj): type =
  eth66

template RecType(MSG: type nodeDataObj): untyped =
  nodeDataObj

template msgId(MSG: type nodeDataObj): int =
  14

type
  receiptsObj = object
    receipts*: seq[seq[Receipt]]

template receipts(PROTO: type eth66): type =
  receiptsObj

template msgProtocol(MSG: type receiptsObj): type =
  eth66

template RecType(MSG: type receiptsObj): untyped =
  receiptsObj

template msgId(MSG: type receiptsObj): int =
  16

type
  getReceiptsObj = object
    hashes*: seq[Hash256]

template getReceipts(PROTO: type eth66): type =
  getReceiptsObj

template msgProtocol(MSG: type getReceiptsObj): type =
  eth66

template RecType(MSG: type getReceiptsObj): untyped =
  getReceiptsObj

template msgId(MSG: type getReceiptsObj): int =
  15

var eth66ProtocolObj = initProtocol("eth", 66, createPeerState,
                                    createNetworkState)
var eth66Protocol = addr eth66ProtocolObj
template protocolInfo(PROTO: type eth66): auto =
  eth66Protocol

proc statusRawSender(peerOrResponder: Peer; ethVersionArg: uint;
                     networkId: NetworkId; totalDifficulty: DifficultyInt;
                     bestHash: Hash256; genesisHash: Hash256;
                     forkId: ChainForkId;
                     timeout: Duration = milliseconds(10000'i64)): Future[void] {.
    gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 0
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 0)
  appendInt(writer, perPeerMsgId)
  startList(writer, 6)
  appendInt(writer, ethVersionArg)
  append(writer, networkId)
  append(writer, totalDifficulty)
  append(writer, bestHash)
  append(writer, genesisHash)
  appendImpl(writer, forkId)
  let msgBytes =
    const
      loc`gensym219 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym219 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template status(peer: Peer; ethVersionArg: uint; networkId: NetworkId;
                totalDifficulty: DifficultyInt; bestHash: Hash256;
                genesisHash: Hash256; forkId: ChainForkId;
                timeout: Duration = milliseconds(10000'i64)): Future[statusObj] =
  let peer_5452595292 = peer
  let sendingFuture`gensym61_5452595970 = statusRawSender(peer, ethVersionArg,
      networkId, totalDifficulty, bestHash, genesisHash, forkId)
  handshakeImpl(peer_5452595292, sendingFuture`gensym61_5452595970,
                nextMsg(peer_5452595292, statusObj), timeout)

proc newBlockHashes(peerOrResponder: Peer;
                    hashes: openArray[NewBlockHashesAnnounce]): Future[void] {.
    gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 1
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 1)
  appendInt(writer, perPeerMsgId)
  appendImpl(writer, hashes)
  let msgBytes =
    const
      loc`gensym236 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym236 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

proc transactions(peerOrResponder: Peer; transactions: openArray[Transaction]): Future[
    void] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 2
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 2)
  appendInt(writer, perPeerMsgId)
  append(writer, transactions)
  let msgBytes =
    const
      loc`gensym243 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym243 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

proc blockHeaders(peerOrResponder: ResponderWithId[blockHeadersObj];
                  headers: openArray[BlockHeader]): Future[void] {.gcsafe.} =
  let peer = peerOrResponder.peer
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 4
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 4)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendInt(writer, peerOrResponder.reqId)
  appendImpl(writer, headers)
  let msgBytes =
    const
      loc`gensym253 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym253 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template send(r`gensym77: ResponderWithId[blockHeadersObj];
              args`gensym77: varargs[untyped]): auto =
  blockHeaders(r`gensym77, args`gensym77)

proc getBlockHeaders(peerOrResponder: Peer; request: BlocksRequest;
                     timeout: Duration = milliseconds(10000'i64)): Future[
    Option[blockHeadersObj]] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 3
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 3)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  appendInt(writer, reqId)
  appendImpl(writer, request)
  let msgBytes =
    const
      loc`gensym287 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym287 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc blockBodies(peerOrResponder: ResponderWithId[blockBodiesObj];
                 blocks: openArray[BlockBody]): Future[void] {.gcsafe.} =
  let peer = peerOrResponder.peer
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 6
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 6)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendInt(writer, peerOrResponder.reqId)
  appendImpl(writer, blocks)
  let msgBytes =
    const
      loc`gensym345 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym345 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template send(r`gensym94: ResponderWithId[blockBodiesObj];
              args`gensym94: varargs[untyped]): auto =
  blockBodies(r`gensym94, args`gensym94)

proc getBlockBodies(peerOrResponder: Peer; hashes: openArray[Hash256];
                    timeout: Duration = milliseconds(10000'i64)): Future[
    Option[blockBodiesObj]] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 5
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 5)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  appendInt(writer, reqId)
  appendImpl(writer, hashes)
  let msgBytes =
    const
      loc`gensym357 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym357 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc newBlock(peerOrResponder: Peer; blk: EthBlock;
              totalDifficulty: DifficultyInt): Future[void] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 7
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 7)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendImpl(writer, blk)
  append(writer, totalDifficulty)
  let msgBytes =
    const
      loc`gensym391 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym391 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

proc newPooledTransactionHashes(peerOrResponder: Peer;
                                txHashes: openArray[Hash256]): Future[void] {.
    gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 8
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 8)
  appendInt(writer, perPeerMsgId)
  appendImpl(writer, txHashes)
  let msgBytes =
    const
      loc`gensym398 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym398 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

proc pooledTransactions(peerOrResponder: ResponderWithId[pooledTransactionsObj];
                        transactions: openArray[Transaction]): Future[void] {.
    gcsafe.} =
  let peer = peerOrResponder.peer
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 10
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 10)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendInt(writer, peerOrResponder.reqId)
  append(writer, transactions)
  let msgBytes =
    const
      loc`gensym406 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym406 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template send(r`gensym124: ResponderWithId[pooledTransactionsObj];
              args`gensym124: varargs[untyped]): auto =
  pooledTransactions(r`gensym124, args`gensym124)

proc getPooledTransactions(peerOrResponder: Peer; txHashes: openArray[Hash256];
                           timeout: Duration = milliseconds(10000'i64)): Future[
    Option[pooledTransactionsObj]] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 9
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 9)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  appendInt(writer, reqId)
  appendImpl(writer, txHashes)
  let msgBytes =
    const
      loc`gensym418 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym418 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc getNodeData(peerOrResponder: Peer; nodeHashes: openArray[Hash256]): Future[
    void] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 13
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 13)
  appendInt(writer, perPeerMsgId)
  appendImpl(writer, nodeHashes)
  let msgBytes =
    const
      loc`gensym427 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym427 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

proc nodeData(peerOrResponder: Peer; data: openArray[Blob]): Future[void] {.
    gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 14
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 14)
  appendInt(writer, perPeerMsgId)
  appendImpl(writer, data)
  let msgBytes =
    const
      loc`gensym435 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym435 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

proc receipts(peerOrResponder: ResponderWithId[receiptsObj];
              receipts: openArray[seq[Receipt]]): Future[void] {.gcsafe.} =
  let peer = peerOrResponder.peer
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 16
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 16)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendInt(writer, peerOrResponder.reqId)
  appendImpl(writer, receipts)
  let msgBytes =
    const
      loc`gensym445 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym445 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template send(r`gensym153: ResponderWithId[receiptsObj];
              args`gensym153: varargs[untyped]): auto =
  receipts(r`gensym153, args`gensym153)

proc getReceipts(peerOrResponder: Peer; hashes: openArray[Hash256];
                 timeout: Duration = milliseconds(10000'i64)): Future[
    Option[receiptsObj]] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 15
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 15)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  appendInt(writer, reqId)
  appendImpl(writer, hashes)
  let msgBytes =
    const
      loc`gensym457 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym457 = "writer.nim(338, 3)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "writer.nim", line: 338, column: 2).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("writer.nim(338, 3) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc statusUserHandler(peer: Peer; ethVersionArg: uint; networkId: NetworkId;
                       totalDifficulty: DifficultyInt; bestHash: Hash256;
                       genesisHash: Hash256; forkId: ChainForkId): Future[void] {.
    gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator statusUserHandler_5452599808(chronosInternalRetFuture: FutureBase;
                                        :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth66
      const
        perProtocolMsgId = 0
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth66Protocol))

      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452599847:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452599847 = default(typeof(record_5452599847))
          discard
          initLogRecord(record_5452599847, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received Status (0x00)")
          setProperty(record_5452599847, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452599847, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_5452599847, "networkId", networkId)
          mixin setProperty, formatItIMPL
          setProperty(record_5452599847, "totalDifficulty", totalDifficulty)
          mixin setProperty, formatItIMPL
          setProperty(record_5452599847, "bestHash", short(bestHash))
          mixin setProperty, formatItIMPL
          setProperty(record_5452599847, "genesisHash", short(genesisHash))
          mixin setProperty, formatItIMPL
          setProperty(record_5452599847, "forkHash", toHex(forkId.forkHash))
          mixin setProperty, formatItIMPL
          setProperty(record_5452599847, "forkNext", forkId.forkNext)
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452599847)
          flushRecord(record_5452599847)
      except CatchableError as err`gensym469:
        logLoggingFailure(cstring("<< [eth/66] Received Status (0x00)"),
                          err`gensym469)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 131, column: 6).filename,
        (filename: "eth66.nim", line: 131, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("statusUserHandler", (filename: "eth66.nim",
        line: 131, column: 6).filename, (filename: "eth66.nim", line: 131,
        column: 6).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (statusUserHandler_5452599808, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockHashesUserHandler(peer: Peer; hashes: seq[NewBlockHashesAnnounce]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockHashesUserHandler_5452600052(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth66
      const
        perProtocolMsgId = 1
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth66Protocol))

      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452600086:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452600086 = default(typeof(record_5452600086))
          discard
          initLogRecord(record_5452600086, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received NewBlockHashes (0x01)")
          setProperty(record_5452600086, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452600086, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_5452600086, "hashes", len(hashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452600086)
          flushRecord(record_5452600086)
      except CatchableError as err`gensym513:
        logLoggingFailure(cstring("<< [eth/66] Received NewBlockHashes (0x01)"),
                          err`gensym513)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      handleNewBlockHashes(ctx, peer, hashes)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 137, column: 4).filename,
        (filename: "eth66.nim", line: 137, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newBlockHashesUserHandler", (
        filename: "eth66.nim", line: 137, column: 4).filename, (
        filename: "eth66.nim", line: 137, column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (newBlockHashesUserHandler_5452600052, :env)
  futureContinue(resultFuture)
  return resultFuture

proc transactionsUserHandler(peer: Peer; transactions: seq[Transaction]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator transactionsUserHandler_5452600338(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth66
      const
        perProtocolMsgId = 2
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth66Protocol))

      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452600372:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452600372 = default(typeof(record_5452600372))
          discard
          initLogRecord(record_5452600372, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received Transactions (0x02)")
          setProperty(record_5452600372, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452600372, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_5452600372, "transactions", len(transactions))
          mixin setProperty, formatItIMPL
          setProperty(record_5452600372, "transactionHash"):
            type
              OutType`gensym545 = typeof(
                block:
                  var it {.inject.}: typeof(items(transactions), typeOfIter)
                  itemID(it), typeOfProc)
            block:
              template s2_5452600443(): untyped =
                transactions
              
              var i`gensym545 = 0
              var result`gensym545 = newSeq(len(transactions))
              for it in items(transactions):
                result`gensym545[i`gensym545] = itemID(it)
                i`gensym545 += 1
              result`gensym545
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452600372)
          flushRecord(record_5452600372)
      except CatchableError as err`gensym536:
        logLoggingFailure(cstring("<< [eth/66] Received Transactions (0x02)"),
                          err`gensym536)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      handleAnnouncedTxs(ctx, peer, transactions)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 146, column: 4).filename,
        (filename: "eth66.nim", line: 146, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("transactionsUserHandler", (filename: "eth66.nim",
        line: 146, column: 4).filename, (filename: "eth66.nim", line: 146,
        column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (transactionsUserHandler_5452600338, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockHeadersUserHandler(peer: Peer; reqId: int; request: BlocksRequest): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockHeadersUserHandler_5452600597(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
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
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452600677:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452600677 = default(typeof(record_5452600677))
          discard
          initLogRecord(record_5452600677, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received GetBlockHeaders (0x03)")
          setProperty(record_5452600677, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452600677, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_5452600677, "count", request.maxResults)
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452600677)
          flushRecord(record_5452600677)
      except CatchableError as err`gensym576:
        logLoggingFailure(cstring("<< [eth/66] Received GetBlockHeaders (0x03)"),
                          err`gensym576)
      if (
        uint64(192) < request.maxResults):
        bind logIMPL, bindSym, brForceOpen
        chronosInternalRetFuture.child = disconnect(peer, BreachOfProtocol,
            false)
        yield chronosInternalRetFuture.child
        if chronosInternalRetFuture.mustCancel:
          raise (ref CancelledError)(msg: "Future operation cancelled!")
        internalCheckComplete(chronosInternalRetFuture.child)
        complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
            (filename: "eth66.nim", line: 154, column: 4).filename,
            (filename: "eth66.nim", line: 154, column: 4).line))
        return nil
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      let headers = getBlockHeaders(ctx, request)
      if (
        0 < len(headers)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_5452600842:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_5452600842 = default(typeof(record_5452600842))
            discard
            initLogRecord(record_5452600842, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying with BlockHeaders (0x04)")
            setProperty(record_5452600842, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_5452600842, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_5452600842, "sent", len(headers))
            mixin setProperty, formatItIMPL
            setProperty(record_5452600842, "requested", request.maxResults)
            logAllDynamicProperties(
              defaultChroniclesStream, record_5452600842)
            flushRecord(record_5452600842)
        except CatchableError as err`gensym618:
          logLoggingFailure(cstring(">> [eth/66] Replying with BlockHeaders (0x04)"),
                            err`gensym618)
      else:
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_5452600933:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_5452600933 = default(typeof(record_5452600933))
            discard
            initLogRecord(record_5452600933, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying EMPTY BlockHeaders (0x04)")
            setProperty(record_5452600933, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_5452600933, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_5452600933, "sent", 0)
            mixin setProperty, formatItIMPL
            setProperty(record_5452600933, "requested", request.maxResults)
            logAllDynamicProperties(
              defaultChroniclesStream, record_5452600933)
            flushRecord(record_5452600933)
        except CatchableError as err`gensym636:
          logLoggingFailure(cstring(">> [eth/66] Replying EMPTY BlockHeaders (0x04)"),
                            err`gensym636)
      chronosInternalRetFuture.child = blockHeaders(response, headers)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 155, column: 6).filename,
        (filename: "eth66.nim", line: 155, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getBlockHeadersUserHandler", (
        filename: "eth66.nim", line: 155, column: 6).filename, (
        filename: "eth66.nim", line: 155, column: 6).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getBlockHeadersUserHandler_5452600597, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockBodiesUserHandler(peer: Peer; reqId: int; hashes: seq[Hash256]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockBodiesUserHandler_5452601032(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
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
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452601076:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452601076 = default(typeof(record_5452601076))
          discard
          initLogRecord(record_5452601076, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received GetBlockBodies (0x05)")
          setProperty(record_5452601076, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452601076, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_5452601076, "hashes", len(hashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452601076)
          flushRecord(record_5452601076)
      except CatchableError as err`gensym664:
        logLoggingFailure(cstring("<< [eth/66] Received GetBlockBodies (0x05)"),
                          err`gensym664)
      if (
        128 < len(hashes)):
        bind logIMPL, bindSym, brForceOpen
        chronosInternalRetFuture.child = disconnect(peer, BreachOfProtocol,
            false)
        yield chronosInternalRetFuture.child
        if chronosInternalRetFuture.mustCancel:
          raise (ref CancelledError)(msg: "Future operation cancelled!")
        internalCheckComplete(chronosInternalRetFuture.child)
        complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
            (filename: "eth66.nim", line: 181, column: 4).filename,
            (filename: "eth66.nim", line: 181, column: 4).line))
        return nil
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      let bodies = getBlockBodies(ctx, hashes)
      if (
        0 < len(bodies)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_5452601204:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_5452601204 = default(typeof(record_5452601204))
            discard
            initLogRecord(record_5452601204, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying with BlockBodies (0x06)")
            setProperty(record_5452601204, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_5452601204, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_5452601204, "sent", len(bodies))
            mixin setProperty, formatItIMPL
            setProperty(record_5452601204, "requested", len(hashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_5452601204)
            flushRecord(record_5452601204)
        except CatchableError as err`gensym694:
          logLoggingFailure(cstring(">> [eth/66] Replying with BlockBodies (0x06)"),
                            err`gensym694)
      else:
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_5452601298:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_5452601298 = default(typeof(record_5452601298))
            discard
            initLogRecord(record_5452601298, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying EMPTY BlockBodies (0x06)")
            setProperty(record_5452601298, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_5452601298, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_5452601298, "sent", 0)
            mixin setProperty, formatItIMPL
            setProperty(record_5452601298, "requested", len(hashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_5452601298)
            flushRecord(record_5452601298)
        except CatchableError as err`gensym712:
          logLoggingFailure(cstring(">> [eth/66] Replying EMPTY BlockBodies (0x06)"),
                            err`gensym712)
      chronosInternalRetFuture.child = blockBodies(response, bodies)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 182, column: 6).filename,
        (filename: "eth66.nim", line: 182, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getBlockBodiesUserHandler", (
        filename: "eth66.nim", line: 182, column: 6).filename, (
        filename: "eth66.nim", line: 182, column: 6).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getBlockBodiesUserHandler_5452601032, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockUserHandler(peer: Peer; blk: EthBlock;
                         totalDifficulty: DifficultyInt): Future[void] {.gcsafe,
    stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockUserHandler_5452601421(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth66
      const
        perProtocolMsgId = 7
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth66Protocol))

      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452601456:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452601456 = default(typeof(record_5452601456))
          discard
          initLogRecord(record_5452601456, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received NewBlock (0x07)")
          setProperty(record_5452601456, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452601456, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_5452601456, "totalDifficulty", totalDifficulty)
          mixin setProperty, formatItIMPL
          setProperty(record_5452601456, "blockNumber", blk.header.blockNumber)
          mixin setProperty, formatItIMPL
          setProperty(record_5452601456, "blockDifficulty",
                      blk.header.difficulty)
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452601456)
          flushRecord(record_5452601456)
      except CatchableError as err`gensym740:
        logLoggingFailure(cstring("<< [eth/66] Received NewBlock (0x07)"),
                          err`gensym740)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      handleNewBlock(ctx, peer, blk, totalDifficulty)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 208, column: 4).filename,
        (filename: "eth66.nim", line: 208, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newBlockUserHandler", (filename: "eth66.nim",
        line: 208, column: 4).filename, (filename: "eth66.nim", line: 208,
        column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (newBlockUserHandler_5452601421, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newPooledTransactionHashesUserHandler(peer: Peer; txHashes: seq[Hash256]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator newPooledTransactionHashesUserHandler_5452601565(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth66
      const
        perProtocolMsgId = 8
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth66Protocol))

      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452601599:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452601599 = default(typeof(record_5452601599))
          discard
          initLogRecord(record_5452601599, LogLevel(INFO), "eth66", "<< [eth/66] Received NewPooledTransactionHashes (0x08)")
          setProperty(record_5452601599, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452601599, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_5452601599, "hashes", len(txHashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452601599)
          flushRecord(record_5452601599)
      except CatchableError as err`gensym767:
        logLoggingFailure(cstring("<< [eth/66] Received NewPooledTransactionHashes (0x08)"),
                          err`gensym767)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      handleAnnouncedTxsHashes(ctx, peer, txHashes)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 219, column: 4).filename,
        (filename: "eth66.nim", line: 219, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newPooledTransactionHashesUserHandler", (
        filename: "eth66.nim", line: 219, column: 4).filename, (
        filename: "eth66.nim", line: 219, column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (newPooledTransactionHashesUserHandler_5452601565, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getPooledTransactionsUserHandler(peer: Peer; reqId: int;
                                      txHashes: seq[Hash256]): Future[void] {.
    gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getPooledTransactionsUserHandler_5452601691(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
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
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452601735:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452601735 = default(typeof(record_5452601735))
          discard
          initLogRecord(record_5452601735, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received GetPooledTransactions (0x09)")
          setProperty(record_5452601735, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452601735, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_5452601735, "hashes", len(txHashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452601735)
          flushRecord(record_5452601735)
      except CatchableError as err`gensym790:
        logLoggingFailure(cstring("<< [eth/66] Received GetPooledTransactions (0x09)"),
                          err`gensym790)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      let txs = getPooledTxs(ctx, txHashes)
      if (
        0 < len(txs)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_5452601824:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_5452601824 = default(typeof(record_5452601824))
            discard
            initLogRecord(record_5452601824, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying with PooledTransactions (0x0a)")
            setProperty(record_5452601824, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_5452601824, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_5452601824, "sent", len(txs))
            mixin setProperty, formatItIMPL
            setProperty(record_5452601824, "requested", len(txHashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_5452601824)
            flushRecord(record_5452601824)
        except CatchableError as err`gensym808:
          logLoggingFailure(cstring(">> [eth/66] Replying with PooledTransactions (0x0a)"),
                            err`gensym808)
      else:
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_5452601918:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_5452601918 = default(typeof(record_5452601918))
            discard
            initLogRecord(record_5452601918, LogLevel(INFO), "eth66", ">> [eth/66] Replying EMPTY PooledTransactions (0x0a)")
            setProperty(record_5452601918, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_5452601918, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_5452601918, "sent", 0)
            mixin setProperty, formatItIMPL
            setProperty(record_5452601918, "requested", len(txHashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_5452601918)
            flushRecord(record_5452601918)
        except CatchableError as err`gensym826:
          logLoggingFailure(cstring(">> [eth/66] Replying EMPTY PooledTransactions (0x0a)"),
                            err`gensym826)
      chronosInternalRetFuture.child = pooledTransactions(response, txs)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 229, column: 6).filename,
        (filename: "eth66.nim", line: 229, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getPooledTransactionsUserHandler", (
        filename: "eth66.nim", line: 229, column: 6).filename, (
        filename: "eth66.nim", line: 229, column: 6).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getPooledTransactionsUserHandler_5452601691, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getNodeDataUserHandler(peer: Peer; nodeHashes: seq[Hash256]): Future[void] {.
    gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getNodeDataUserHandler_5452602020(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth66
      const
        perProtocolMsgId = 13
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth66Protocol))

      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452602054:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452602054 = default(typeof(record_5452602054))
          discard
          initLogRecord(record_5452602054, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received GetNodeData (0x0d)")
          setProperty(record_5452602054, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452602054, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_5452602054, "hashes", len(nodeHashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452602054)
          flushRecord(record_5452602054)
      except CatchableError as err`gensym854:
        logLoggingFailure(cstring("<< [eth/66] Received GetNodeData (0x0d)"),
                          err`gensym854)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      let data = getStorageNodes(ctx, nodeHashes)
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452602137:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452602137 = default(typeof(record_5452602137))
          discard
          initLogRecord(record_5452602137, LogLevel(INFO), "eth66",
                        ">> [eth/66] Replying NodeData (0x0e)")
          setProperty(record_5452602137, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452602137, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_5452602137, "sent", len(data))
          mixin setProperty, formatItIMPL
          setProperty(record_5452602137, "requested", len(nodeHashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452602137)
          flushRecord(record_5452602137)
      except CatchableError as err`gensym871:
        logLoggingFailure(cstring(">> [eth/66] Replying NodeData (0x0e)"),
                          err`gensym871)
      chronosInternalRetFuture.child = nodeData(peer, data)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 250, column: 4).filename,
        (filename: "eth66.nim", line: 250, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getNodeDataUserHandler", (filename: "eth66.nim",
        line: 250, column: 4).filename, (filename: "eth66.nim", line: 250,
        column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getNodeDataUserHandler_5452602020, :env)
  futureContinue(resultFuture)
  return resultFuture

proc nodeDataUserHandler(peer: Peer; data: seq[Blob]): Future[void] {.gcsafe,
    stackTrace: false, gcsafe, raises: [].} =
  iterator nodeDataUserHandler_5452602263(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth66
      const
        perProtocolMsgId = 14
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth66Protocol))

      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452602297:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452602297 = default(typeof(record_5452602297))
          discard
          initLogRecord(record_5452602297, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received NodeData (0x0e)")
          setProperty(record_5452602297, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452602297, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_5452602297, "bytes", len(data))
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452602297)
          flushRecord(record_5452602297)
      except CatchableError as err`gensym898:
        logLoggingFailure(cstring("<< [eth/66] Received NodeData (0x0e)"),
                          err`gensym898)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      handleNodeData(ctx, peer, data)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 263, column: 4).filename,
        (filename: "eth66.nim", line: 263, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("nodeDataUserHandler", (filename: "eth66.nim",
        line: 263, column: 4).filename, (filename: "eth66.nim", line: 263,
        column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (nodeDataUserHandler_5452602263, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getReceiptsUserHandler(peer: Peer; reqId: int; hashes: seq[Hash256]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getReceiptsUserHandler_5452602389(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
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
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452602433:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452602433 = default(typeof(record_5452602433))
          discard
          initLogRecord(record_5452602433, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received GetReceipts (0x0f)")
          setProperty(record_5452602433, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452602433, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_5452602433, "hashes", len(hashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452602433)
          flushRecord(record_5452602433)
      except CatchableError as err`gensym921:
        logLoggingFailure(cstring("<< [eth/66] Received GetReceipts (0x0f)"),
                          err`gensym921)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      let rec = getReceipts(ctx, hashes)
      if (
        0 < len(rec)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_5452602522:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_5452602522 = default(typeof(record_5452602522))
            discard
            initLogRecord(record_5452602522, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying with Receipts (0x10)")
            setProperty(record_5452602522, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_5452602522, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_5452602522, "sent", len(rec))
            mixin setProperty, formatItIMPL
            setProperty(record_5452602522, "requested", len(hashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_5452602522)
            flushRecord(record_5452602522)
        except CatchableError as err`gensym939:
          logLoggingFailure(cstring(">> [eth/66] Replying with Receipts (0x10)"),
                            err`gensym939)
      else:
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_5452602616:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_5452602616 = default(typeof(record_5452602616))
            discard
            initLogRecord(record_5452602616, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying EMPTY Receipts (0x10)")
            setProperty(record_5452602616, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_5452602616, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_5452602616, "sent", 0)
            mixin setProperty, formatItIMPL
            setProperty(record_5452602616, "requested", len(hashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_5452602616)
            flushRecord(record_5452602616)
        except CatchableError as err`gensym957:
          logLoggingFailure(cstring(">> [eth/66] Replying EMPTY Receipts (0x10)"),
                            err`gensym957)
      chronosInternalRetFuture.child = receipts(response, rec)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 271, column: 6).filename,
        (filename: "eth66.nim", line: 271, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getReceiptsUserHandler", (filename: "eth66.nim",
        line: 271, column: 6).filename, (filename: "eth66.nim", line: 271,
        column: 6).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getReceiptsUserHandler_5452602389, :env)
  futureContinue(resultFuture)
  return resultFuture

proc statusThunk(peer: Peer; __5452602742: int; data`gensym56: Rlp): Future[void] {.
    gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator statusThunk_5452602739(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
      closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym56
      var msg {.noinit.}: statusObj
      tryEnterList(rlp)
      msg.ethVersionArg = checkedRlpRead(peer, rlp, uint)
      msg.networkId = checkedRlpRead(peer, rlp, NetworkId)
      msg.totalDifficulty = checkedRlpRead(peer, rlp, DifficultyInt)
      msg.bestHash = checkedRlpRead(peer, rlp, Hash256)
      msg.genesisHash = checkedRlpRead(peer, rlp, Hash256)
      msg.forkId = checkedRlpRead(peer, rlp, ChainForkId)
      chronosInternalRetFuture.child = statusUserHandler(peer,
          msg.ethVersionArg, msg.networkId, msg.totalDifficulty, msg.bestHash,
          msg.genesisHash, msg.forkId)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("statusThunk", (filename: "rlpx.nim", line: 966,
        column: 8).filename, (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (statusThunk_5452602739, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockHashesThunk(peer: Peer; __5452603017: int; data`gensym63: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockHashesThunk_5452603014(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym63
      var msg {.noinit.}: newBlockHashesObj
      msg.hashes = checkedRlpRead(peer, rlp, openArray[NewBlockHashesAnnounce])
      chronosInternalRetFuture.child = newBlockHashesUserHandler(peer,
          msg.hashes)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newBlockHashesThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (newBlockHashesThunk_5452603014, :env)
  futureContinue(resultFuture)
  return resultFuture

proc transactionsThunk(peer: Peer; __5452603217: int; data`gensym69: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator transactionsThunk_5452603214(chronosInternalRetFuture: FutureBase;
                                        :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym69
      var msg {.noinit.}: transactionsObj
      msg.transactions = checkedRlpRead(peer, rlp, openArray[Transaction])
      chronosInternalRetFuture.child = transactionsUserHandler(peer,
          msg.transactions)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("transactionsThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (transactionsThunk_5452603214, :env)
  futureContinue(resultFuture)
  return resultFuture

proc blockHeadersThunk(peer: Peer; __5452603302: int; data`gensym76: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator blockHeadersThunk_5452603299(chronosInternalRetFuture: FutureBase;
                                        :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym76
      var msg {.noinit.}: blockHeadersObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.headers = checkedRlpRead(peer, rlp, openArray[BlockHeader])
      resolveResponseFuture(peer, perPeerMsgIdImpl(peer, eth66Protocol, 4),
                            addr(msg), reqId)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("blockHeadersThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (blockHeadersThunk_5452603299, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockHeadersThunk(peer: Peer; __5452603410: int; data`gensym86: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockHeadersThunk_5452603407(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym86
      var msg {.noinit.}: getBlockHeadersObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.request = checkedRlpRead(peer, rlp, BlocksRequest)
      chronosInternalRetFuture.child = getBlockHeadersUserHandler(peer, reqId,
          msg.request)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getBlockHeadersThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getBlockHeadersThunk_5452603407, :env)
  futureContinue(resultFuture)
  return resultFuture

proc blockBodiesThunk(peer: Peer; __5452603689: int; data`gensym93: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator blockBodiesThunk_5452603686(chronosInternalRetFuture: FutureBase;
                                       :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym93
      var msg {.noinit.}: blockBodiesObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.blocks = checkedRlpRead(peer, rlp, openArray[BlockBody])
      resolveResponseFuture(peer, perPeerMsgIdImpl(peer, eth66Protocol, 6),
                            addr(msg), reqId)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("blockBodiesThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (blockBodiesThunk_5452603686, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockBodiesThunk(peer: Peer; __5452603956: int; data`gensym103: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockBodiesThunk_5452603953(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym103
      var msg {.noinit.}: getBlockBodiesObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.hashes = checkedRlpRead(peer, rlp, openArray[Hash256])
      chronosInternalRetFuture.child = getBlockBodiesUserHandler(peer, reqId,
          msg.hashes)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getBlockBodiesThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getBlockBodiesThunk_5452603953, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockThunk(peer: Peer; __5452604041: int; data`gensym110: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockThunk_5452604038(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
      closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym110
      var msg {.noinit.}: newBlockObj
      tryEnterList(rlp)
      msg.blk = checkedRlpRead(peer, rlp, EthBlock)
      msg.totalDifficulty = checkedRlpRead(peer, rlp, DifficultyInt)
      chronosInternalRetFuture.child = newBlockUserHandler(peer, msg.blk,
          msg.totalDifficulty)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newBlockThunk", (filename: "rlpx.nim", line: 966,
        column: 8).filename, (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (newBlockThunk_5452604038, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newPooledTransactionHashesThunk(peer: Peer; __5452604149: int;
                                     data`gensym116: Rlp): Future[void] {.
    gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator newPooledTransactionHashesThunk_5452604146(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym116
      var msg {.noinit.}: newPooledTransactionHashesObj
      msg.txHashes = checkedRlpRead(peer, rlp, openArray[Hash256])
      chronosInternalRetFuture.child = newPooledTransactionHashesUserHandler(
          peer, msg.txHashes)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newPooledTransactionHashesThunk", (
        filename: "rlpx.nim", line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (newPooledTransactionHashesThunk_5452604146, :env)
  futureContinue(resultFuture)
  return resultFuture

proc pooledTransactionsThunk(peer: Peer; __5452604214: int; data`gensym123: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator pooledTransactionsThunk_5452604211(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym123
      var msg {.noinit.}: pooledTransactionsObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.transactions = checkedRlpRead(peer, rlp, openArray[Transaction])
      resolveResponseFuture(peer, perPeerMsgIdImpl(peer, eth66Protocol, 10),
                            addr(msg), reqId)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("pooledTransactionsThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (pooledTransactionsThunk_5452604211, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getPooledTransactionsThunk(peer: Peer; __5452604309: int;
                                data`gensym133: Rlp): Future[void] {.gcsafe,
    raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getPooledTransactionsThunk_5452604306(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym133
      var msg {.noinit.}: getPooledTransactionsObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.txHashes = checkedRlpRead(peer, rlp, openArray[Hash256])
      chronosInternalRetFuture.child = getPooledTransactionsUserHandler(peer,
          reqId, msg.txHashes)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getPooledTransactionsThunk", (
        filename: "rlpx.nim", line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getPooledTransactionsThunk_5452604306, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getNodeDataThunk(peer: Peer; __5452604381: int; data`gensym139: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getNodeDataThunk_5452604378(chronosInternalRetFuture: FutureBase;
                                       :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym139
      var msg {.noinit.}: getNodeDataObj
      msg.nodeHashes = checkedRlpRead(peer, rlp, openArray[Hash256])
      chronosInternalRetFuture.child = getNodeDataUserHandler(peer,
          msg.nodeHashes)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getNodeDataThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getNodeDataThunk_5452604378, :env)
  futureContinue(resultFuture)
  return resultFuture

proc nodeDataThunk(peer: Peer; __5452604446: int; data`gensym145: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator nodeDataThunk_5452604443(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
      closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym145
      var msg {.noinit.}: nodeDataObj
      msg.data = checkedRlpRead(peer, rlp, openArray[Blob])
      chronosInternalRetFuture.child = nodeDataUserHandler(peer, msg.data)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("nodeDataThunk", (filename: "rlpx.nim", line: 966,
        column: 8).filename, (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (nodeDataThunk_5452604443, :env)
  futureContinue(resultFuture)
  return resultFuture

proc receiptsThunk(peer: Peer; __5452604542: int; data`gensym152: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator receiptsThunk_5452604539(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
      closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym152
      var msg {.noinit.}: receiptsObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.receipts = checkedRlpRead(peer, rlp, openArray[seq[Receipt]])
      resolveResponseFuture(peer, perPeerMsgIdImpl(peer, eth66Protocol, 16),
                            addr(msg), reqId)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("receiptsThunk", (filename: "rlpx.nim", line: 966,
        column: 8).filename, (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (receiptsThunk_5452604539, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getReceiptsThunk(peer: Peer; __5452604951: int; data`gensym162: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getReceiptsThunk_5452604948(chronosInternalRetFuture: FutureBase;
                                       :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym162
      var msg {.noinit.}: getReceiptsObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.hashes = checkedRlpRead(peer, rlp, openArray[Hash256])
      chronosInternalRetFuture.child = getReceiptsUserHandler(peer, reqId,
          msg.hashes)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getReceiptsThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getReceiptsThunk_5452604948, :env)
  futureContinue(resultFuture)
  return resultFuture

registerMsg(eth66Protocol, 0, "status", statusThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth66Protocol, 1, "newBlockHashes", newBlockHashesThunk,
            messagePrinter, requestResolver, nextMsgResolver)
registerMsg(eth66Protocol, 2, "transactions", transactionsThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth66Protocol, 4, "blockHeaders", blockHeadersThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth66Protocol, 3, "getBlockHeaders", getBlockHeadersThunk,
            messagePrinter, requestResolver, nextMsgResolver)
registerMsg(eth66Protocol, 6, "blockBodies", blockBodiesThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth66Protocol, 5, "getBlockBodies", getBlockBodiesThunk,
            messagePrinter, requestResolver, nextMsgResolver)
registerMsg(eth66Protocol, 7, "newBlock", newBlockThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth66Protocol, 8, "newPooledTransactionHashes",
            newPooledTransactionHashesThunk, messagePrinter, requestResolver,
            nextMsgResolver)
registerMsg(eth66Protocol, 10, "pooledTransactions", pooledTransactionsThunk,
            messagePrinter, requestResolver, nextMsgResolver)
registerMsg(eth66Protocol, 9, "getPooledTransactions",
            getPooledTransactionsThunk, messagePrinter, requestResolver,
            nextMsgResolver)
registerMsg(eth66Protocol, 13, "getNodeData", getNodeDataThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth66Protocol, 14, "nodeData", nodeDataThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth66Protocol, 16, "receipts", receiptsThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth66Protocol, 15, "getReceipts", getReceiptsThunk, messagePrinter,
            requestResolver, nextMsgResolver)
proc eth66PeerConnected(peer: Peer): Future[void] {.gcsafe, stackTrace: false,
    gcsafe, raises: [].} =
  iterator eth66PeerConnected_5452613108(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth66
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth66Protocol))

      let
        network = peer.network
        ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth66Protocol))
        status = getStatus(ctx)
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452613143:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452613143 = default(typeof(record_5452613143))
          discard
          initLogRecord(record_5452613143, LogLevel(INFO), "eth66",
                        ">> [eth/66] Sending Status (0x00)")
          setProperty(record_5452613143, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452613143, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_5452613143, "td", status.totalDifficulty)
          mixin setProperty, formatItIMPL
          setProperty(record_5452613143, "bestHash", short(status.bestBlockHash))
          mixin setProperty, formatItIMPL
          setProperty(record_5452613143, "networkId", network.networkId)
          mixin setProperty, formatItIMPL
          setProperty(record_5452613143, "genesis", short(status.genesisHash))
          mixin setProperty, formatItIMPL
          setProperty(record_5452613143, "forkHash", status.forkId.forkHash)
          mixin setProperty, formatItIMPL
          setProperty(record_5452613143, "forkNext", status.forkId.forkNext)
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452613143)
          flushRecord(record_5452613143)
      except CatchableError as err`gensym1951:
        logLoggingFailure(cstring(">> [eth/66] Sending Status (0x00)"),
                          err`gensym1951)
      let remote =
        chronosInternalRetFuture.child =
          let peer_5452595292 = peer
          let sendingFuture`gensym61`gensym1982 = statusRawSender(peer, 66,
              network.networkId, status.totalDifficulty, status.bestBlockHash,
              status.genesisHash, status.forkId, milliseconds(10000'i64))
          handshakeImpl(peer_5452595292, sendingFuture`gensym61`gensym1982,
                        nextMsg(peer_5452595292, statusObj), seconds(10))
        yield chronosInternalRetFuture.child
        if chronosInternalRetFuture.mustCancel:
          raise (ref CancelledError)(msg: "Future operation cancelled!")
        internalCheckComplete(chronosInternalRetFuture.child)
        internalRead(cast[type do:
          let peer_5452595292 = peer
          let sendingFuture`gensym61`gensym1982 = statusRawSender(peer, 66,
              network.networkId, status.totalDifficulty, status.bestBlockHash,
              status.genesisHash, status.forkId, milliseconds(10000'i64))
          handshakeImpl(peer_5452595292, sendingFuture`gensym61`gensym1982,
                        nextMsg(peer_5452595292, statusObj), seconds(10))](chronosInternalRetFuture.child))
      echo ["remote:", remote]
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452614574:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452614574 = default(typeof(record_5452614574))
          discard
          initLogRecord(record_5452614574, LogLevel(INFO), "eth66",
                        "Handshake: Local and remote networkId")
          setProperty(record_5452614574, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452614574, "local", network.networkId)
          mixin setProperty, formatItIMPL
          setProperty(record_5452614574, "remote", remote.networkId)
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452614574)
          flushRecord(record_5452614574)
      except CatchableError as err`gensym2092:
        logLoggingFailure(cstring("Handshake: Local and remote networkId"),
                          err`gensym2092)
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452614653:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452614653 = default(typeof(record_5452614653))
          discard
          initLogRecord(record_5452614653, LogLevel(INFO), "eth66",
                        "Handshake: Local and remote genesisHash")
          setProperty(record_5452614653, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452614653, "local", status.genesisHash)
          mixin setProperty, formatItIMPL
          setProperty(record_5452614653, "remote", remote.genesisHash)
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452614653)
          flushRecord(record_5452614653)
      except CatchableError as err`gensym2108:
        logLoggingFailure(cstring("Handshake: Local and remote genesisHash"),
                          err`gensym2108)
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452614812:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452614812 = default(typeof(record_5452614812))
          discard
          initLogRecord(record_5452614812, LogLevel(INFO), "eth66",
                        "Handshake: Local and remote forkId")
          setProperty(record_5452614812, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452614812, "local", toHex(status.forkId.forkHash) &
              "/" &
              $status.forkId.forkNext)
          mixin setProperty, formatItIMPL
          setProperty(record_5452614812, "remote", toHex(remote.forkId.forkHash) &
              "/" &
              $remote.forkId.forkNext)
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452614812)
          flushRecord(record_5452614812)
      except CatchableError as err`gensym2136:
        logLoggingFailure(cstring("Handshake: Local and remote forkId"),
                          err`gensym2136)
      if (
        not (remote.networkId == network.networkId)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_5452615001:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_5452615001 = default(typeof(record_5452615001))
            discard
            initLogRecord(record_5452615001, LogLevel(INFO), "eth66",
                          "Peer for a different network (networkId)")
            setProperty(record_5452615001, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_5452615001, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_5452615001, "expectNetworkId", network.networkId)
            mixin setProperty, formatItIMPL
            setProperty(record_5452615001, "gotNetworkId", remote.networkId)
            logAllDynamicProperties(
              defaultChroniclesStream, record_5452615001)
            flushRecord(record_5452615001)
        except CatchableError as err`gensym2153:
          logLoggingFailure(cstring("Peer for a different network (networkId)"),
                            err`gensym2153)
        raise
          (ref UselessPeerError)(msg: "Eth handshake for different network",
                                 parent: nil)
      if (
        not (remote.genesisHash == status.genesisHash)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_5452615158:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_5452615158 = default(typeof(record_5452615158))
            discard
            initLogRecord(record_5452615158, LogLevel(INFO), "eth66",
                          "Peer for a different network (genesisHash)")
            setProperty(record_5452615158, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_5452615158, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_5452615158, "expectGenesis",
                        short(status.genesisHash))
            mixin setProperty, formatItIMPL
            setProperty(record_5452615158, "gotGenesis",
                        short(remote.genesisHash))
            logAllDynamicProperties(
              defaultChroniclesStream, record_5452615158)
            flushRecord(record_5452615158)
        except CatchableError as err`gensym2173:
          logLoggingFailure(cstring("Peer for a different network (genesisHash)"),
                            err`gensym2173)
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_5452615246:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_5452615246 = default(typeof(record_5452615246))
          discard
          initLogRecord(record_5452615246, LogLevel(INFO), "eth66",
                        "Peer matches our network")
          setProperty(record_5452615246, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_5452615246, "peer", $peer.remote)
          logAllDynamicProperties(
            defaultChroniclesStream, record_5452615246)
          flushRecord(record_5452615246)
      except CatchableError as err`gensym2191:
        logLoggingFailure(cstring("Peer matches our network"), err`gensym2191)
      cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol)).initialized = true
      cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol)).bestDifficulty = remote.totalDifficulty
      cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol)).bestBlockHash = remote.bestHash
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 75, column: 4).filename,
        (filename: "eth66.nim", line: 75, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("eth66PeerConnected", (filename: "eth66.nim",
        line: 75, column: 4).filename,
                             (filename: "eth66.nim", line: 75, column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (eth66PeerConnected_5452613108, :env)
  futureContinue(resultFuture)
  return resultFuture

setEventHandlers(eth66Protocol, eth66PeerConnected, nil)
registerProtocol(eth66Protocol)