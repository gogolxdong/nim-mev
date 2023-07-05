
## Generated at line 79
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
  let peer_7079985209 = peer
  let sendingFuture`gensym61_7079985906 = statusRawSender(peer, ethVersionArg,
      networkId, totalDifficulty, bestHash, genesisHash, forkId)
  handshakeImpl(peer_7079985209, sendingFuture`gensym61_7079985906,
                nextMsg(peer_7079985209, statusObj), timeout)

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
      loc`gensym242 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym242 = "writer.nim(338, 3)"
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
      loc`gensym251 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym251 = "writer.nim(338, 3)"
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
      loc`gensym285 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym285 = "writer.nim(338, 3)"
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
      loc`gensym296 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym296 = "writer.nim(338, 3)"
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
      loc`gensym308 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym308 = "writer.nim(338, 3)"
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
      loc`gensym317 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym317 = "writer.nim(338, 3)"
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
      loc`gensym324 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym324 = "writer.nim(338, 3)"
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
      loc`gensym332 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym332 = "writer.nim(338, 3)"
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
      loc`gensym344 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym344 = "writer.nim(338, 3)"
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
      loc`gensym353 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym353 = "writer.nim(338, 3)"
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
      loc`gensym360 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym360 = "writer.nim(338, 3)"
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
      loc`gensym369 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym369 = "writer.nim(338, 3)"
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
      loc`gensym381 = (filename: "writer.nim", line: 338, column: 2)
      ploc`gensym381 = "writer.nim(338, 3)"
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
  iterator statusUserHandler_7079987406(chronosInternalRetFuture: FutureBase;
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
          var record_7079987445:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_7079987445 = default(typeof(record_7079987445))
          discard
          initLogRecord(record_7079987445, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received Status (0x00)")
          setProperty(record_7079987445, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_7079987445, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_7079987445, "networkId", networkId)
          mixin setProperty, formatItIMPL
          setProperty(record_7079987445, "totalDifficulty", totalDifficulty)
          mixin setProperty, formatItIMPL
          setProperty(record_7079987445, "bestHash", short(bestHash))
          mixin setProperty, formatItIMPL
          setProperty(record_7079987445, "genesisHash", short(genesisHash))
          mixin setProperty, formatItIMPL
          setProperty(record_7079987445, "forkHash", toHex(forkId.forkHash))
          mixin setProperty, formatItIMPL
          setProperty(record_7079987445, "forkNext", forkId.forkNext)
          logAllDynamicProperties(
            defaultChroniclesStream, record_7079987445)
          flushRecord(record_7079987445)
      except CatchableError as err`gensym393:
        logLoggingFailure(cstring("<< [eth/66] Received Status (0x00)"),
                          err`gensym393)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 142, column: 6).filename,
        (filename: "eth66.nim", line: 142, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("statusUserHandler", (filename: "eth66.nim",
        line: 142, column: 6).filename, (filename: "eth66.nim", line: 142,
        column: 6).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (statusUserHandler_7079987406, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockHashesUserHandler(peer: Peer; hashes: seq[NewBlockHashesAnnounce]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockHashesUserHandler_7079987604(
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

      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      handleNewBlockHashes(ctx, peer, hashes)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 148, column: 4).filename,
        (filename: "eth66.nim", line: 148, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newBlockHashesUserHandler", (
        filename: "eth66.nim", line: 148, column: 4).filename, (
        filename: "eth66.nim", line: 148, column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (newBlockHashesUserHandler_7079987604, :env)
  futureContinue(resultFuture)
  return resultFuture

proc transactionsUserHandler(peer: Peer; transactions: seq[Transaction]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator transactionsUserHandler_7079987809(
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

      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      handleAnnouncedTxs(ctx, peer, transactions)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 157, column: 4).filename,
        (filename: "eth66.nim", line: 157, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("transactionsUserHandler", (filename: "eth66.nim",
        line: 157, column: 4).filename, (filename: "eth66.nim", line: 157,
        column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (transactionsUserHandler_7079987809, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockHeadersUserHandler(peer: Peer; reqId: int; request: BlocksRequest): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockHeadersUserHandler_7079987854(
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
          var record_7079987898:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_7079987898 = default(typeof(record_7079987898))
          discard
          initLogRecord(record_7079987898, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received GetBlockHeaders (0x03)")
          setProperty(record_7079987898, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_7079987898, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_7079987898, "count", request.maxResults)
          logAllDynamicProperties(
            defaultChroniclesStream, record_7079987898)
          flushRecord(record_7079987898)
      except CatchableError as err`gensym439:
        logLoggingFailure(cstring("<< [eth/66] Received GetBlockHeaders (0x03)"),
                          err`gensym439)
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
            (filename: "eth66.nim", line: 166, column: 4).filename,
            (filename: "eth66.nim", line: 166, column: 4).line))
        return nil
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      let headers = getBlockHeaders(ctx, request)
      if (
        0 < len(headers)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_7079988017:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_7079988017 = default(typeof(record_7079988017))
            discard
            initLogRecord(record_7079988017, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying with BlockHeaders (0x04)")
            setProperty(record_7079988017, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_7079988017, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_7079988017, "sent", len(headers))
            mixin setProperty, formatItIMPL
            setProperty(record_7079988017, "requested", request.maxResults)
            logAllDynamicProperties(
              defaultChroniclesStream, record_7079988017)
            flushRecord(record_7079988017)
        except CatchableError as err`gensym469:
          logLoggingFailure(cstring(">> [eth/66] Replying with BlockHeaders (0x04)"),
                            err`gensym469)
      else:
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_7079988108:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_7079988108 = default(typeof(record_7079988108))
            discard
            initLogRecord(record_7079988108, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying EMPTY BlockHeaders (0x04)")
            setProperty(record_7079988108, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_7079988108, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_7079988108, "sent", 0)
            mixin setProperty, formatItIMPL
            setProperty(record_7079988108, "requested", request.maxResults)
            logAllDynamicProperties(
              defaultChroniclesStream, record_7079988108)
            flushRecord(record_7079988108)
        except CatchableError as err`gensym487:
          logLoggingFailure(cstring(">> [eth/66] Replying EMPTY BlockHeaders (0x04)"),
                            err`gensym487)
      chronosInternalRetFuture.child = blockHeaders(response, headers)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 167, column: 6).filename,
        (filename: "eth66.nim", line: 167, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getBlockHeadersUserHandler", (
        filename: "eth66.nim", line: 167, column: 6).filename, (
        filename: "eth66.nim", line: 167, column: 6).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getBlockHeadersUserHandler_7079987854, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockBodiesUserHandler(peer: Peer; reqId: int; hashes: seq[Hash256]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockBodiesUserHandler_7079988207(
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
          var record_7079988251:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_7079988251 = default(typeof(record_7079988251))
          discard
          initLogRecord(record_7079988251, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received GetBlockBodies (0x05)")
          setProperty(record_7079988251, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_7079988251, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_7079988251, "hashes", len(hashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_7079988251)
          flushRecord(record_7079988251)
      except CatchableError as err`gensym515:
        logLoggingFailure(cstring("<< [eth/66] Received GetBlockBodies (0x05)"),
                          err`gensym515)
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
            (filename: "eth66.nim", line: 193, column: 4).filename,
            (filename: "eth66.nim", line: 193, column: 4).line))
        return nil
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      let bodies = getBlockBodies(ctx, hashes)
      if (
        0 < len(bodies)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_7079988379:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_7079988379 = default(typeof(record_7079988379))
            discard
            initLogRecord(record_7079988379, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying with BlockBodies (0x06)")
            setProperty(record_7079988379, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_7079988379, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_7079988379, "sent", len(bodies))
            mixin setProperty, formatItIMPL
            setProperty(record_7079988379, "requested", len(hashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_7079988379)
            flushRecord(record_7079988379)
        except CatchableError as err`gensym545:
          logLoggingFailure(cstring(">> [eth/66] Replying with BlockBodies (0x06)"),
                            err`gensym545)
      else:
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_7079988473:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_7079988473 = default(typeof(record_7079988473))
            discard
            initLogRecord(record_7079988473, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying EMPTY BlockBodies (0x06)")
            setProperty(record_7079988473, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_7079988473, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_7079988473, "sent", 0)
            mixin setProperty, formatItIMPL
            setProperty(record_7079988473, "requested", len(hashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_7079988473)
            flushRecord(record_7079988473)
        except CatchableError as err`gensym563:
          logLoggingFailure(cstring(">> [eth/66] Replying EMPTY BlockBodies (0x06)"),
                            err`gensym563)
      chronosInternalRetFuture.child = blockBodies(response, bodies)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 194, column: 6).filename,
        (filename: "eth66.nim", line: 194, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getBlockBodiesUserHandler", (
        filename: "eth66.nim", line: 194, column: 6).filename, (
        filename: "eth66.nim", line: 194, column: 6).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getBlockBodiesUserHandler_7079988207, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockUserHandler(peer: Peer; blk: EthBlock;
                         totalDifficulty: DifficultyInt): Future[void] {.gcsafe,
    stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockUserHandler_7079988575(chronosInternalRetFuture: FutureBase;
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

      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      handleNewBlock(ctx, peer, blk, totalDifficulty)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 220, column: 4).filename,
        (filename: "eth66.nim", line: 220, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newBlockUserHandler", (filename: "eth66.nim",
        line: 220, column: 4).filename, (filename: "eth66.nim", line: 220,
        column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (newBlockUserHandler_7079988575, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newPooledTransactionHashesUserHandler(peer: Peer; txHashes: seq[Hash256]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator newPooledTransactionHashesUserHandler_7079988621(
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

      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      handleAnnouncedTxsHashes(ctx, peer, txHashes)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 231, column: 4).filename,
        (filename: "eth66.nim", line: 231, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newPooledTransactionHashesUserHandler", (
        filename: "eth66.nim", line: 231, column: 4).filename, (
        filename: "eth66.nim", line: 231, column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (newPooledTransactionHashesUserHandler_7079988621, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getPooledTransactionsUserHandler(peer: Peer; reqId: int;
                                      txHashes: seq[Hash256]): Future[void] {.
    gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getPooledTransactionsUserHandler_7079988666(
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
          var record_7079988710:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_7079988710 = default(typeof(record_7079988710))
          discard
          initLogRecord(record_7079988710, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received GetPooledTransactions (0x09)")
          setProperty(record_7079988710, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_7079988710, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_7079988710, "hashes", len(txHashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_7079988710)
          flushRecord(record_7079988710)
      except CatchableError as err`gensym605:
        logLoggingFailure(cstring("<< [eth/66] Received GetPooledTransactions (0x09)"),
                          err`gensym605)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      let txs = getPooledTxs(ctx, txHashes)
      if (
        0 < len(txs)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_7079988799:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_7079988799 = default(typeof(record_7079988799))
            discard
            initLogRecord(record_7079988799, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying with PooledTransactions (0x0a)")
            setProperty(record_7079988799, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_7079988799, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_7079988799, "sent", len(txs))
            mixin setProperty, formatItIMPL
            setProperty(record_7079988799, "requested", len(txHashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_7079988799)
            flushRecord(record_7079988799)
        except CatchableError as err`gensym623:
          logLoggingFailure(cstring(">> [eth/66] Replying with PooledTransactions (0x0a)"),
                            err`gensym623)
      else:
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_7079988893:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_7079988893 = default(typeof(record_7079988893))
            discard
            initLogRecord(record_7079988893, LogLevel(INFO), "eth66", ">> [eth/66] Replying EMPTY PooledTransactions (0x0a)")
            setProperty(record_7079988893, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_7079988893, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_7079988893, "sent", 0)
            mixin setProperty, formatItIMPL
            setProperty(record_7079988893, "requested", len(txHashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_7079988893)
            flushRecord(record_7079988893)
        except CatchableError as err`gensym641:
          logLoggingFailure(cstring(">> [eth/66] Replying EMPTY PooledTransactions (0x0a)"),
                            err`gensym641)
      chronosInternalRetFuture.child = pooledTransactions(response, txs)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 241, column: 6).filename,
        (filename: "eth66.nim", line: 241, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getPooledTransactionsUserHandler", (
        filename: "eth66.nim", line: 241, column: 6).filename, (
        filename: "eth66.nim", line: 241, column: 6).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getPooledTransactionsUserHandler_7079988666, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getNodeDataUserHandler(peer: Peer; nodeHashes: seq[Hash256]): Future[void] {.
    gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getNodeDataUserHandler_7079988995(
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
          var record_7079989029:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_7079989029 = default(typeof(record_7079989029))
          discard
          initLogRecord(record_7079989029, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received GetNodeData (0x0d)")
          setProperty(record_7079989029, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_7079989029, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_7079989029, "hashes", len(nodeHashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_7079989029)
          flushRecord(record_7079989029)
      except CatchableError as err`gensym669:
        logLoggingFailure(cstring("<< [eth/66] Received GetNodeData (0x0d)"),
                          err`gensym669)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      let data = getStorageNodes(ctx, nodeHashes)
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_7079989112:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_7079989112 = default(typeof(record_7079989112))
          discard
          initLogRecord(record_7079989112, LogLevel(INFO), "eth66",
                        ">> [eth/66] Replying NodeData (0x0e)")
          setProperty(record_7079989112, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_7079989112, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_7079989112, "sent", len(data))
          mixin setProperty, formatItIMPL
          setProperty(record_7079989112, "requested", len(nodeHashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_7079989112)
          flushRecord(record_7079989112)
      except CatchableError as err`gensym686:
        logLoggingFailure(cstring(">> [eth/66] Replying NodeData (0x0e)"),
                          err`gensym686)
      chronosInternalRetFuture.child = nodeData(peer, data)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 262, column: 4).filename,
        (filename: "eth66.nim", line: 262, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getNodeDataUserHandler", (filename: "eth66.nim",
        line: 262, column: 4).filename, (filename: "eth66.nim", line: 262,
        column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getNodeDataUserHandler_7079988995, :env)
  futureContinue(resultFuture)
  return resultFuture

proc nodeDataUserHandler(peer: Peer; data: seq[Blob]): Future[void] {.gcsafe,
    stackTrace: false, gcsafe, raises: [].} =
  iterator nodeDataUserHandler_7079989217(chronosInternalRetFuture: FutureBase;
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
          var record_7079989251:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_7079989251 = default(typeof(record_7079989251))
          discard
          initLogRecord(record_7079989251, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received NodeData (0x0e)")
          setProperty(record_7079989251, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_7079989251, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_7079989251, "bytes", len(data))
          logAllDynamicProperties(
            defaultChroniclesStream, record_7079989251)
          flushRecord(record_7079989251)
      except CatchableError as err`gensym713:
        logLoggingFailure(cstring("<< [eth/66] Received NodeData (0x0e)"),
                          err`gensym713)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      handleNodeData(ctx, peer, data)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 275, column: 4).filename,
        (filename: "eth66.nim", line: 275, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("nodeDataUserHandler", (filename: "eth66.nim",
        line: 275, column: 4).filename, (filename: "eth66.nim", line: 275,
        column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (nodeDataUserHandler_7079989217, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getReceiptsUserHandler(peer: Peer; reqId: int; hashes: seq[Hash256]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getReceiptsUserHandler_7079989343(
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
          var record_7079989387:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_7079989387 = default(typeof(record_7079989387))
          discard
          initLogRecord(record_7079989387, LogLevel(INFO), "eth66",
                        "<< [eth/66] Received GetReceipts (0x0f)")
          setProperty(record_7079989387, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_7079989387, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_7079989387, "hashes", len(hashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_7079989387)
          flushRecord(record_7079989387)
      except CatchableError as err`gensym736:
        logLoggingFailure(cstring("<< [eth/66] Received GetReceipts (0x0f)"),
                          err`gensym736)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      let rec = getReceipts(ctx, hashes)
      if (
        0 < len(rec)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_7079989476:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_7079989476 = default(typeof(record_7079989476))
            discard
            initLogRecord(record_7079989476, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying with Receipts (0x10)")
            setProperty(record_7079989476, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_7079989476, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_7079989476, "sent", len(rec))
            mixin setProperty, formatItIMPL
            setProperty(record_7079989476, "requested", len(hashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_7079989476)
            flushRecord(record_7079989476)
        except CatchableError as err`gensym754:
          logLoggingFailure(cstring(">> [eth/66] Replying with Receipts (0x10)"),
                            err`gensym754)
      else:
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_7079989570:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_7079989570 = default(typeof(record_7079989570))
            discard
            initLogRecord(record_7079989570, LogLevel(INFO), "eth66",
                          ">> [eth/66] Replying EMPTY Receipts (0x10)")
            setProperty(record_7079989570, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_7079989570, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_7079989570, "sent", 0)
            mixin setProperty, formatItIMPL
            setProperty(record_7079989570, "requested", len(hashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_7079989570)
            flushRecord(record_7079989570)
        except CatchableError as err`gensym772:
          logLoggingFailure(cstring(">> [eth/66] Replying EMPTY Receipts (0x10)"),
                            err`gensym772)
      chronosInternalRetFuture.child = receipts(response, rec)
      yield chronosInternalRetFuture.child
      if chronosInternalRetFuture.mustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.child)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 283, column: 6).filename,
        (filename: "eth66.nim", line: 283, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getReceiptsUserHandler", (filename: "eth66.nim",
        line: 283, column: 6).filename, (filename: "eth66.nim", line: 283,
        column: 6).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (getReceiptsUserHandler_7079989343, :env)
  futureContinue(resultFuture)
  return resultFuture

proc statusThunk(peer: Peer; __7079989675: int; data`gensym56: Rlp): Future[void] {.
    gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator statusThunk_7079989672(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
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
    (statusThunk_7079989672, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockHashesThunk(peer: Peer; __7079989841: int; data`gensym63: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockHashesThunk_7079989838(chronosInternalRetFuture: FutureBase;
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
    (newBlockHashesThunk_7079989838, :env)
  futureContinue(resultFuture)
  return resultFuture

proc transactionsThunk(peer: Peer; __7079990019: int; data`gensym69: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator transactionsThunk_7079990016(chronosInternalRetFuture: FutureBase;
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
    (transactionsThunk_7079990016, :env)
  futureContinue(resultFuture)
  return resultFuture

proc blockHeadersThunk(peer: Peer; __7079990062: int; data`gensym76: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator blockHeadersThunk_7079990059(chronosInternalRetFuture: FutureBase;
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
    (blockHeadersThunk_7079990059, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockHeadersThunk(peer: Peer; __7079990116: int; data`gensym86: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockHeadersThunk_7079990113(chronosInternalRetFuture: FutureBase;
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
    (getBlockHeadersThunk_7079990113, :env)
  futureContinue(resultFuture)
  return resultFuture

proc blockBodiesThunk(peer: Peer; __7079990322: int; data`gensym93: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator blockBodiesThunk_7079990319(chronosInternalRetFuture: FutureBase;
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
    (blockBodiesThunk_7079990319, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockBodiesThunk(peer: Peer; __7079990376: int; data`gensym103: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockBodiesThunk_7079990373(chronosInternalRetFuture: FutureBase;
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
    (getBlockBodiesThunk_7079990373, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockThunk(peer: Peer; __7079990426: int; data`gensym110: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockThunk_7079990423(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
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
    (newBlockThunk_7079990423, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newPooledTransactionHashesThunk(peer: Peer; __7079990474: int;
                                     data`gensym116: Rlp): Future[void] {.
    gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator newPooledTransactionHashesThunk_7079990471(
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
    (newPooledTransactionHashesThunk_7079990471, :env)
  futureContinue(resultFuture)
  return resultFuture

proc pooledTransactionsThunk(peer: Peer; __7079990517: int; data`gensym123: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator pooledTransactionsThunk_7079990514(
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
    (pooledTransactionsThunk_7079990514, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getPooledTransactionsThunk(peer: Peer; __7079990571: int;
                                data`gensym133: Rlp): Future[void] {.gcsafe,
    raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getPooledTransactionsThunk_7079990568(
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
    (getPooledTransactionsThunk_7079990568, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getNodeDataThunk(peer: Peer; __7079990621: int; data`gensym139: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getNodeDataThunk_7079990618(chronosInternalRetFuture: FutureBase;
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
    (getNodeDataThunk_7079990618, :env)
  futureContinue(resultFuture)
  return resultFuture

proc nodeDataThunk(peer: Peer; __7079990664: int; data`gensym145: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator nodeDataThunk_7079990661(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
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
    (nodeDataThunk_7079990661, :env)
  futureContinue(resultFuture)
  return resultFuture

proc receiptsThunk(peer: Peer; __7079990707: int; data`gensym152: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator receiptsThunk_7079990704(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
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
    (receiptsThunk_7079990704, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getReceiptsThunk(peer: Peer; __7079990761: int; data`gensym162: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getReceiptsThunk_7079990758(chronosInternalRetFuture: FutureBase;
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
    (getReceiptsThunk_7079990758, :env)
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
  iterator eth66PeerConnected_7079995961(chronosInternalRetFuture: FutureBase;
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
          var record_7079995996:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_7079995996 = default(typeof(record_7079995996))
          discard
          initLogRecord(record_7079995996, LogLevel(INFO), "eth66",
                        ">> [eth/66] Sending Status (0x00)")
          setProperty(record_7079995996, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_7079995996, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_7079995996, "td", status.totalDifficulty)
          mixin setProperty, formatItIMPL
          setProperty(record_7079995996, "bestHash", short(status.bestBlockHash))
          mixin setProperty, formatItIMPL
          setProperty(record_7079995996, "networkId", network.networkId)
          mixin setProperty, formatItIMPL
          setProperty(record_7079995996, "genesis", short(status.genesisHash))
          mixin setProperty, formatItIMPL
          setProperty(record_7079995996, "forkHash",
                      toHex(status.forkId.forkHash))
          mixin setProperty, formatItIMPL
          setProperty(record_7079995996, "forkNext", status.forkId.forkNext)
          logAllDynamicProperties(
            defaultChroniclesStream, record_7079995996)
          flushRecord(record_7079995996)
      except CatchableError as err`gensym1717:
        logLoggingFailure(cstring(">> [eth/66] Sending Status (0x00)"),
                          err`gensym1717)
      let m =
        chronosInternalRetFuture.child =
          let peer_7079985209 = peer
          let sendingFuture`gensym61`gensym1736 = statusRawSender(peer, 66,
              network.networkId, status.totalDifficulty, status.bestBlockHash,
              status.genesisHash, status.forkId, milliseconds(10000'i64))
          handshakeImpl(peer_7079985209, sendingFuture`gensym61`gensym1736,
                        nextMsg(peer_7079985209, statusObj), seconds(10))
        yield chronosInternalRetFuture.child
        if chronosInternalRetFuture.mustCancel:
          raise (ref CancelledError)(msg: "Future operation cancelled!")
        internalCheckComplete(chronosInternalRetFuture.child)
        internalRead(cast[type do:
          let peer_7079985209 = peer
          let sendingFuture`gensym61`gensym1736 = statusRawSender(peer, 66,
              network.networkId, status.totalDifficulty, status.bestBlockHash,
              status.genesisHash, status.forkId, milliseconds(10000'i64))
          handshakeImpl(peer_7079985209, sendingFuture`gensym61`gensym1736,
                        nextMsg(peer_7079985209, statusObj), seconds(10))](chronosInternalRetFuture.child))
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_7079996466:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_7079996466 = default(typeof(record_7079996466))
          discard
          initLogRecord(record_7079996466, LogLevel(INFO), "eth66",
                        "Handshake: Local and remote networkId")
          setProperty(record_7079996466, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_7079996466, "local", network.networkId)
          mixin setProperty, formatItIMPL
          setProperty(record_7079996466, "remote", m.networkId)
          logAllDynamicProperties(
            defaultChroniclesStream, record_7079996466)
          flushRecord(record_7079996466)
      except CatchableError as err`gensym1787:
        logLoggingFailure(cstring("Handshake: Local and remote networkId"),
                          err`gensym1787)
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_7079996545:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_7079996545 = default(typeof(record_7079996545))
          discard
          initLogRecord(record_7079996545, LogLevel(INFO), "eth66",
                        "Handshake: Local and remote genesisHash")
          setProperty(record_7079996545, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_7079996545, "local", status.genesisHash)
          mixin setProperty, formatItIMPL
          setProperty(record_7079996545, "remote", m.genesisHash)
          logAllDynamicProperties(
            defaultChroniclesStream, record_7079996545)
          flushRecord(record_7079996545)
      except CatchableError as err`gensym1803:
        logLoggingFailure(cstring("Handshake: Local and remote genesisHash"),
                          err`gensym1803)
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_7079996624:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_7079996624 = default(typeof(record_7079996624))
          discard
          initLogRecord(record_7079996624, LogLevel(INFO), "eth66",
                        "Handshake: Local and remote forkId")
          setProperty(record_7079996624, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_7079996624, "local", toHex(status.forkId.forkHash) &
              "/" &
              $status.forkId.forkNext)
          mixin setProperty, formatItIMPL
          setProperty(record_7079996624, "remote",
                      toHex(m.forkId.forkHash) & "/" & $m.forkId.forkNext)
          logAllDynamicProperties(
            defaultChroniclesStream, record_7079996624)
          flushRecord(record_7079996624)
      except CatchableError as err`gensym1819:
        logLoggingFailure(cstring("Handshake: Local and remote forkId"),
                          err`gensym1819)
      if (
        not (m.networkId == network.networkId)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_7079996813:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_7079996813 = default(typeof(record_7079996813))
            discard
            initLogRecord(record_7079996813, LogLevel(INFO), "eth66",
                          "Peer for a different network (networkId)")
            setProperty(record_7079996813, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_7079996813, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_7079996813, "expectNetworkId", network.networkId)
            mixin setProperty, formatItIMPL
            setProperty(record_7079996813, "gotNetworkId", m.networkId)
            logAllDynamicProperties(
              defaultChroniclesStream, record_7079996813)
            flushRecord(record_7079996813)
        except CatchableError as err`gensym1836:
          logLoggingFailure(cstring("Peer for a different network (networkId)"),
                            err`gensym1836)
        raise
          (ref UselessPeerError)(msg: "Eth handshake for different network",
                                 parent: nil)
      if (
        not (m.genesisHash == status.genesisHash)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            var record_7079996970:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_7079996970 = default(typeof(record_7079996970))
            discard
            initLogRecord(record_7079996970, LogLevel(INFO), "eth66",
                          "Peer for a different network (genesisHash)")
            setProperty(record_7079996970, "tid", getLogThreadId())
            mixin setProperty, formatItIMPL
            setProperty(record_7079996970, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_7079996970, "expectGenesis",
                        short(status.genesisHash))
            mixin setProperty, formatItIMPL
            setProperty(record_7079996970, "gotGenesis", short(m.genesisHash))
            logAllDynamicProperties(
              defaultChroniclesStream, record_7079996970)
            flushRecord(record_7079996970)
        except CatchableError as err`gensym1856:
          logLoggingFailure(cstring("Peer for a different network (genesisHash)"),
                            err`gensym1856)
        raise
          (ref UselessPeerError)(msg: "Eth handshake for different network",
                                 parent: nil)
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          var record_7079997059:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_7079997059 = default(typeof(record_7079997059))
          discard
          initLogRecord(record_7079997059, LogLevel(INFO), "eth66",
                        "Peer matches our network")
          setProperty(record_7079997059, "tid", getLogThreadId())
          mixin setProperty, formatItIMPL
          setProperty(record_7079997059, "peer", $peer.remote)
          logAllDynamicProperties(
            defaultChroniclesStream, record_7079997059)
          flushRecord(record_7079997059)
      except CatchableError as err`gensym1875:
        logLoggingFailure(cstring("Peer matches our network"), err`gensym1875)
      cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol)).initialized = true
      cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol)).bestDifficulty = m.totalDifficulty
      cast[ref[EthPeerState:ObjectType]](getState(peer, eth66Protocol)).bestBlockHash = m.bestHash
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 86, column: 4).filename,
        (filename: "eth66.nim", line: 86, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("eth66PeerConnected", (filename: "eth66.nim",
        line: 86, column: 4).filename,
                             (filename: "eth66.nim", line: 86, column: 4).line))
  resultFuture.closure =
    var :env
    :env = [type node]()
    :env.`:up` = :env
    (eth66PeerConnected_7079995961, :env)
  futureContinue(resultFuture)
  return resultFuture

setEventHandlers(eth66Protocol, eth66PeerConnected, nil)
registerProtocol(eth66Protocol)