
## Generated at line 79
type
  eth67 = object
template State(PROTO: type eth67): type =
  ref[EthPeerState:ObjectType]

template NetworkState(PROTO: type eth67): type =
  ref[EthWireBase:ObjectType]

type
  statusObj = object
    ethVersionArg*: uint
    networkId*: NetworkId
    totalDifficulty*: DifficultyInt
    bestHash*: Hash256
    genesisHash*: Hash256
    forkId*: ChainForkId

template status(PROTO: type eth67): type =
  statusObj

template msgProtocol(MSG: type statusObj): type =
  eth67

template RecType(MSG: type statusObj): untyped =
  statusObj

template msgId(MSG: type statusObj): int =
  0

type
  newBlockHashesObj = object
    hashes*: seq[NewBlockHashesAnnounce]

template newBlockHashes(PROTO: type eth67): type =
  newBlockHashesObj

template msgProtocol(MSG: type newBlockHashesObj): type =
  eth67

template RecType(MSG: type newBlockHashesObj): untyped =
  newBlockHashesObj

template msgId(MSG: type newBlockHashesObj): int =
  1

type
  transactionsObj = object
    transactions*: seq[Transaction]

template transactions(PROTO: type eth67): type =
  transactionsObj

template msgProtocol(MSG: type transactionsObj): type =
  eth67

template RecType(MSG: type transactionsObj): untyped =
  transactionsObj

template msgId(MSG: type transactionsObj): int =
  2

type
  blockHeadersObj = object
    headers*: seq[BlockHeader]

template blockHeaders(PROTO: type eth67): type =
  blockHeadersObj

template msgProtocol(MSG: type blockHeadersObj): type =
  eth67

template RecType(MSG: type blockHeadersObj): untyped =
  blockHeadersObj

template msgId(MSG: type blockHeadersObj): int =
  4

type
  getBlockHeadersObj = object
    request*: BlocksRequest

template getBlockHeaders(PROTO: type eth67): type =
  getBlockHeadersObj

template msgProtocol(MSG: type getBlockHeadersObj): type =
  eth67

template RecType(MSG: type getBlockHeadersObj): untyped =
  getBlockHeadersObj

template msgId(MSG: type getBlockHeadersObj): int =
  3

type
  blockBodiesObj = object
    blocks*: seq[BlockBody]

template blockBodies(PROTO: type eth67): type =
  blockBodiesObj

template msgProtocol(MSG: type blockBodiesObj): type =
  eth67

template RecType(MSG: type blockBodiesObj): untyped =
  blockBodiesObj

template msgId(MSG: type blockBodiesObj): int =
  6

type
  getBlockBodiesObj = object
    hashes*: seq[Hash256]

template getBlockBodies(PROTO: type eth67): type =
  getBlockBodiesObj

template msgProtocol(MSG: type getBlockBodiesObj): type =
  eth67

template RecType(MSG: type getBlockBodiesObj): untyped =
  getBlockBodiesObj

template msgId(MSG: type getBlockBodiesObj): int =
  5

type
  newBlockObj = object
    blk*: EthBlock
    totalDifficulty*: DifficultyInt

template newBlock(PROTO: type eth67): type =
  newBlockObj

template msgProtocol(MSG: type newBlockObj): type =
  eth67

template RecType(MSG: type newBlockObj): untyped =
  newBlockObj

template msgId(MSG: type newBlockObj): int =
  7

type
  newPooledTransactionHashesObj = object
    txHashes*: seq[Hash256]

template newPooledTransactionHashes(PROTO: type eth67): type =
  newPooledTransactionHashesObj

template msgProtocol(MSG: type newPooledTransactionHashesObj): type =
  eth67

template RecType(MSG: type newPooledTransactionHashesObj): untyped =
  newPooledTransactionHashesObj

template msgId(MSG: type newPooledTransactionHashesObj): int =
  8

type
  pooledTransactionsObj = object
    transactions*: seq[Transaction]

template pooledTransactions(PROTO: type eth67): type =
  pooledTransactionsObj

template msgProtocol(MSG: type pooledTransactionsObj): type =
  eth67

template RecType(MSG: type pooledTransactionsObj): untyped =
  pooledTransactionsObj

template msgId(MSG: type pooledTransactionsObj): int =
  10

type
  getPooledTransactionsObj = object
    txHashes*: seq[Hash256]

template getPooledTransactions(PROTO: type eth67): type =
  getPooledTransactionsObj

template msgProtocol(MSG: type getPooledTransactionsObj): type =
  eth67

template RecType(MSG: type getPooledTransactionsObj): untyped =
  getPooledTransactionsObj

template msgId(MSG: type getPooledTransactionsObj): int =
  9

type
  receiptsObj = object
    receipts*: seq[seq[Receipt]]

template receipts(PROTO: type eth67): type =
  receiptsObj

template msgProtocol(MSG: type receiptsObj): type =
  eth67

template RecType(MSG: type receiptsObj): untyped =
  receiptsObj

template msgId(MSG: type receiptsObj): int =
  16

type
  getReceiptsObj = object
    hashes*: seq[Hash256]

template getReceipts(PROTO: type eth67): type =
  getReceiptsObj

template msgProtocol(MSG: type getReceiptsObj): type =
  eth67

template RecType(MSG: type getReceiptsObj): untyped =
  getReceiptsObj

template msgId(MSG: type getReceiptsObj): int =
  15

var eth67ProtocolObj = initProtocol("eth", 67, createPeerState,
                                    createNetworkState)
var eth67Protocol = addr eth67ProtocolObj
template protocolInfo(PROTO: type eth67): auto =
  eth67Protocol

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
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth67Protocol, 0)
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
      loc`gensym195 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym195 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template status(peer: Peer; ethVersionArg: uint; networkId: NetworkId;
                totalDifficulty: DifficultyInt; bestHash: Hash256;
                genesisHash: Hash256; forkId: ChainForkId;
                timeout: Duration = milliseconds(10000'i64)): Future[statusObj] =
  let peer_9227468887 = peer
  let sendingFuture`gensym53_9227469487 = statusRawSender(peer, ethVersionArg,
      networkId, totalDifficulty, bestHash, genesisHash, forkId)
  handshakeImpl(peer_9227468887, sendingFuture`gensym53_9227469487,
                nextMsg(peer_9227468887, statusObj), timeout)

proc newBlockHashes(peerOrResponder: Peer;
                    hashes: openArray[NewBlockHashesAnnounce]): Future[void] {.
    gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 1
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth67Protocol, 1)
  appendInt(writer, perPeerMsgId)
  appendImpl(writer, hashes)
  let msgBytes =
    const
      loc`gensym212 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym212 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

proc transactions(peerOrResponder: Peer; transactions: openArray[Transaction]): Future[
    void] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 2
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth67Protocol, 2)
  appendInt(writer, perPeerMsgId)
  append(writer, transactions)
  let msgBytes =
    const
      loc`gensym219 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym219 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

proc blockHeaders(peerOrResponder: ResponderWithId[blockHeadersObj];
                  headers: openArray[BlockHeader]): Future[void] {.gcsafe.} =
  let peer = peerOrResponder.peer
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 4
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth67Protocol, 4)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendInt(writer, peerOrResponder.reqId)
  appendImpl(writer, headers)
  let msgBytes =
    const
      loc`gensym228 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym228 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template send(r`gensym69: ResponderWithId[blockHeadersObj];
              args`gensym69: varargs[untyped]): auto =
  blockHeaders(r`gensym69, args`gensym69)

proc getBlockHeaders(peerOrResponder: Peer; request: BlocksRequest;
                     timeout: Duration = milliseconds(10000'i64)): Future[
    Option[blockHeadersObj]] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 3
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth67Protocol, 3)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  appendInt(writer, reqId)
  appendImpl(writer, request)
  let msgBytes =
    const
      loc`gensym261 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym261 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc blockBodies(peerOrResponder: ResponderWithId[blockBodiesObj];
                 blocks: openArray[BlockBody]): Future[void] {.gcsafe.} =
  let peer = peerOrResponder.peer
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 6
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth67Protocol, 6)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendInt(writer, peerOrResponder.reqId)
  appendImpl(writer, blocks)
  let msgBytes =
    const
      loc`gensym297 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym297 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template send(r`gensym86: ResponderWithId[blockBodiesObj];
              args`gensym86: varargs[untyped]): auto =
  blockBodies(r`gensym86, args`gensym86)

proc getBlockBodies(peerOrResponder: Peer; hashes: openArray[Hash256];
                    timeout: Duration = milliseconds(10000'i64)): Future[
    Option[blockBodiesObj]] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 5
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth67Protocol, 5)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  appendInt(writer, reqId)
  appendImpl(writer, hashes)
  let msgBytes =
    const
      loc`gensym308 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym308 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc newBlock(peerOrResponder: Peer; blk: EthBlock;
              totalDifficulty: DifficultyInt): Future[void] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 7
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth67Protocol, 7)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendImpl(writer, blk)
  append(writer, totalDifficulty)
  let msgBytes =
    const
      loc`gensym342 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym342 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

proc newPooledTransactionHashes(peerOrResponder: Peer;
                                txHashes: openArray[Hash256]): Future[void] {.
    gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 8
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth67Protocol, 8)
  appendInt(writer, perPeerMsgId)
  appendImpl(writer, txHashes)
  let msgBytes =
    const
      loc`gensym349 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym349 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

proc pooledTransactions(peerOrResponder: ResponderWithId[pooledTransactionsObj];
                        transactions: openArray[Transaction]): Future[void] {.
    gcsafe.} =
  let peer = peerOrResponder.peer
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 10
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth67Protocol, 10)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendInt(writer, peerOrResponder.reqId)
  append(writer, transactions)
  let msgBytes =
    const
      loc`gensym357 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym357 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template send(r`gensym116: ResponderWithId[pooledTransactionsObj];
              args`gensym116: varargs[untyped]): auto =
  pooledTransactions(r`gensym116, args`gensym116)

proc getPooledTransactions(peerOrResponder: Peer; txHashes: openArray[Hash256];
                           timeout: Duration = milliseconds(10000'i64)): Future[
    Option[pooledTransactionsObj]] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 9
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth67Protocol, 9)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  appendInt(writer, reqId)
  appendImpl(writer, txHashes)
  let msgBytes =
    const
      loc`gensym368 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym368 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc receipts(peerOrResponder: ResponderWithId[receiptsObj];
              receipts: openArray[seq[Receipt]]): Future[void] {.gcsafe.} =
  let peer = peerOrResponder.peer
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 16
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth67Protocol, 16)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendInt(writer, peerOrResponder.reqId)
  appendImpl(writer, receipts)
  let msgBytes =
    const
      loc`gensym380 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym380 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template send(r`gensym133: ResponderWithId[receiptsObj];
              args`gensym133: varargs[untyped]): auto =
  receipts(r`gensym133, args`gensym133)

proc getReceipts(peerOrResponder: Peer; hashes: openArray[Hash256];
                 timeout: Duration = milliseconds(10000'i64)): Future[
    Option[receiptsObj]] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 15
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth67Protocol, 15)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  appendInt(writer, reqId)
  appendImpl(writer, hashes)
  let msgBytes =
    const
      loc`gensym391 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym391 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc statusUserHandler(peer: Peer; ethVersionArg: uint; networkId: NetworkId;
                       totalDifficulty: DifficultyInt; bestHash: Hash256;
                       genesisHash: Hash256; forkId: ChainForkId): Future[void] {.
    gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator statusUserHandler_9227471981(chronosInternalRetFuture: FutureBase;
                                        :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth67
      const
        perProtocolMsgId = 0
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth67Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth67Protocol))

      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
        except:
          discard
        {.pop.}
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth67.nim", line: 142, column: 6).filename,
        (filename: "eth67.nim", line: 142, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("statusUserHandler", (filename: "eth67.nim",
        line: 142, column: 6).filename, (filename: "eth67.nim", line: 142,
        column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    (statusUserHandler_9227471981, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockHashesUserHandler(peer: Peer; hashes: seq[NewBlockHashesAnnounce]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockHashesUserHandler_9227472049(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth67
      const
        perProtocolMsgId = 1
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth67Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth67Protocol))

      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth67Protocol))
      handleNewBlockHashes(ctx, peer, hashes)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth67.nim", line: 148, column: 4).filename,
        (filename: "eth67.nim", line: 148, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newBlockHashesUserHandler", (
        filename: "eth67.nim", line: 148, column: 4).filename, (
        filename: "eth67.nim", line: 148, column: 4).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (newBlockHashesUserHandler_9227472049, :env)
  futureContinue(resultFuture)
  return resultFuture

proc transactionsUserHandler(peer: Peer; transactions: seq[Transaction]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator transactionsUserHandler_9227472112(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth67
      const
        perProtocolMsgId = 2
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth67Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth67Protocol))

      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth67Protocol))
      handleAnnouncedTxs(ctx, peer, transactions)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth67.nim", line: 157, column: 4).filename,
        (filename: "eth67.nim", line: 157, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("transactionsUserHandler", (filename: "eth67.nim",
        line: 157, column: 4).filename, (filename: "eth67.nim", line: 157,
        column: 4).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (transactionsUserHandler_9227472112, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockHeadersUserHandler(peer: Peer; reqId: int; request: BlocksRequest): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockHeadersUserHandler_9227472157(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth67
      const
        perProtocolMsgId = 3
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth67Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth67Protocol))

      var response = init(ResponderWithId[blockHeadersObj], peer, reqId)
      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
        except:
          discard
        {.pop.}
      if (
        uint64(192) < request.maxResults):
        bind logIMPL, bindSym, brForceOpen
        chronosInternalRetFuture.internalChild = disconnect(peer,
            BreachOfProtocol, false)
        yield chronosInternalRetFuture.internalChild
        if chronosInternalRetFuture.internalMustCancel:
          raise (ref CancelledError)(msg: "Future operation cancelled!")
        internalCheckComplete(chronosInternalRetFuture.internalChild)
        complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
            (filename: "eth67.nim", line: 166, column: 4).filename,
            (filename: "eth67.nim", line: 166, column: 4).line))
        return nil
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth67Protocol))
      let headers = getBlockHeaders(ctx, request)
      if (
        0 < len(headers)):
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
          except:
            discard
          {.pop.}
      else:
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
          except:
            discard
          {.pop.}
      chronosInternalRetFuture.internalChild = blockHeaders(response, headers)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth67.nim", line: 167, column: 6).filename,
        (filename: "eth67.nim", line: 167, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getBlockHeadersUserHandler", (
        filename: "eth67.nim", line: 167, column: 6).filename, (
        filename: "eth67.nim", line: 167, column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getBlockHeadersUserHandler_9227472157, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockBodiesUserHandler(peer: Peer; reqId: int; hashes: seq[Hash256]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockBodiesUserHandler_9227472319(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth67
      const
        perProtocolMsgId = 5
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth67Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth67Protocol))

      var response = init(ResponderWithId[blockBodiesObj], peer, reqId)
      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
        except:
          discard
        {.pop.}
      if (
        128 < len(hashes)):
        bind logIMPL, bindSym, brForceOpen
        chronosInternalRetFuture.internalChild = disconnect(peer,
            BreachOfProtocol, false)
        yield chronosInternalRetFuture.internalChild
        if chronosInternalRetFuture.internalMustCancel:
          raise (ref CancelledError)(msg: "Future operation cancelled!")
        internalCheckComplete(chronosInternalRetFuture.internalChild)
        complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
            (filename: "eth67.nim", line: 193, column: 4).filename,
            (filename: "eth67.nim", line: 193, column: 4).line))
        return nil
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth67Protocol))
      let bodies = getBlockBodies(ctx, hashes)
      if (
        0 < len(bodies)):
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
          except:
            discard
          {.pop.}
      else:
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
          except:
            discard
          {.pop.}
      chronosInternalRetFuture.internalChild = blockBodies(response, bodies)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth67.nim", line: 194, column: 6).filename,
        (filename: "eth67.nim", line: 194, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getBlockBodiesUserHandler", (
        filename: "eth67.nim", line: 194, column: 6).filename, (
        filename: "eth67.nim", line: 194, column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getBlockBodiesUserHandler_9227472319, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockUserHandler(peer: Peer; blk: EthBlock;
                         totalDifficulty: DifficultyInt): Future[void] {.gcsafe,
    stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockUserHandler_9227472479(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth67
      const
        perProtocolMsgId = 7
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth67Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth67Protocol))

      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth67Protocol))
      handleNewBlock(ctx, peer, blk, totalDifficulty)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth67.nim", line: 220, column: 4).filename,
        (filename: "eth67.nim", line: 220, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newBlockUserHandler", (filename: "eth67.nim",
        line: 220, column: 4).filename, (filename: "eth67.nim", line: 220,
        column: 4).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (newBlockUserHandler_9227472479, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newPooledTransactionHashesUserHandler(peer: Peer; txHashes: seq[Hash256]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator newPooledTransactionHashesUserHandler_9227472525(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth67
      const
        perProtocolMsgId = 8
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth67Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth67Protocol))

      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth67Protocol))
      handleAnnouncedTxsHashes(ctx, peer, txHashes)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth67.nim", line: 231, column: 4).filename,
        (filename: "eth67.nim", line: 231, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newPooledTransactionHashesUserHandler", (
        filename: "eth67.nim", line: 231, column: 4).filename, (
        filename: "eth67.nim", line: 231, column: 4).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (newPooledTransactionHashesUserHandler_9227472525, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getPooledTransactionsUserHandler(peer: Peer; reqId: int;
                                      txHashes: seq[Hash256]): Future[void] {.
    gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getPooledTransactionsUserHandler_9227472570(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth67
      const
        perProtocolMsgId = 9
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth67Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth67Protocol))

      var response = init(ResponderWithId[pooledTransactionsObj], peer, reqId)
      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
        except:
          discard
        {.pop.}
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth67Protocol))
      let txs = getPooledTxs(ctx, txHashes)
      if (
        0 < len(txs)):
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
          except:
            discard
          {.pop.}
      else:
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
          except:
            discard
          {.pop.}
      chronosInternalRetFuture.internalChild = pooledTransactions(response, txs)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth67.nim", line: 241, column: 6).filename,
        (filename: "eth67.nim", line: 241, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getPooledTransactionsUserHandler", (
        filename: "eth67.nim", line: 241, column: 6).filename, (
        filename: "eth67.nim", line: 241, column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getPooledTransactionsUserHandler_9227472570, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getReceiptsUserHandler(peer: Peer; reqId: int; hashes: seq[Hash256]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getReceiptsUserHandler_9227472690(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth67
      const
        perProtocolMsgId = 15
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth67Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth67Protocol))

      var response = init(ResponderWithId[receiptsObj], peer, reqId)
      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
        except:
          discard
        {.pop.}
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth67Protocol))
      let rec = getReceipts(ctx, hashes)
      if (
        0 < len(rec)):
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
          except:
            discard
          {.pop.}
      else:
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
          except:
            discard
          {.pop.}
      chronosInternalRetFuture.internalChild = receipts(response, rec)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth67.nim", line: 266, column: 6).filename,
        (filename: "eth67.nim", line: 266, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getReceiptsUserHandler", (filename: "eth67.nim",
        line: 266, column: 6).filename, (filename: "eth67.nim", line: 266,
        column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getReceiptsUserHandler_9227472690, :env)
  futureContinue(resultFuture)
  return resultFuture

proc statusThunk(peer: Peer; _`gensym48: int; data`gensym48: Rlp): Future[void] {.
    gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator statusThunk_9227472829(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
      closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym48
      var msg: statusObj
      tryEnterList(rlp)
      msg.ethVersionArg = checkedRlpRead(peer, rlp, uint)
      msg.networkId = checkedRlpRead(peer, rlp, NetworkId)
      msg.totalDifficulty = checkedRlpRead(peer, rlp, DifficultyInt)
      msg.bestHash = checkedRlpRead(peer, rlp, Hash256)
      msg.genesisHash = checkedRlpRead(peer, rlp, Hash256)
      msg.forkId = checkedRlpRead(peer, rlp, ChainForkId)
      chronosInternalRetFuture.internalChild = statusUserHandler(peer,
          msg.ethVersionArg, msg.networkId, msg.totalDifficulty, msg.bestHash,
          msg.genesisHash, msg.forkId)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("statusThunk", (filename: "rlpx.nim", line: 966,
        column: 8).filename, (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (statusThunk_9227472829, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockHashesThunk(peer: Peer; _`gensym55: int; data`gensym55: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockHashesThunk_9227473181(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym55
      var msg: newBlockHashesObj
      msg.hashes = checkedRlpRead(peer, rlp, openArray[NewBlockHashesAnnounce])
      chronosInternalRetFuture.internalChild = newBlockHashesUserHandler(peer,
          msg.hashes)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newBlockHashesThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (newBlockHashesThunk_9227473181, :env)
  futureContinue(resultFuture)
  return resultFuture

proc transactionsThunk(peer: Peer; _`gensym61: int; data`gensym61: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator transactionsThunk_9227473354(chronosInternalRetFuture: FutureBase;
                                        :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym61
      var msg: transactionsObj
      msg.transactions = checkedRlpRead(peer, rlp, openArray[Transaction])
      chronosInternalRetFuture.internalChild = transactionsUserHandler(peer,
          msg.transactions)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("transactionsThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (transactionsThunk_9227473354, :env)
  futureContinue(resultFuture)
  return resultFuture

proc blockHeadersThunk(peer: Peer; _`gensym68: int; data`gensym68: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator blockHeadersThunk_9227473428(chronosInternalRetFuture: FutureBase;
                                        :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym68
      var msg: blockHeadersObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.headers = checkedRlpRead(peer, rlp, openArray[BlockHeader])
      resolveResponseFuture(peer, perPeerMsgIdImpl(peer, eth67Protocol, 4),
                            addr(msg), reqId)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("blockHeadersThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (blockHeadersThunk_9227473428, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockHeadersThunk(peer: Peer; _`gensym78: int; data`gensym78: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockHeadersThunk_9227473515(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym78
      var msg: getBlockHeadersObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.request = checkedRlpRead(peer, rlp, BlocksRequest)
      chronosInternalRetFuture.internalChild = getBlockHeadersUserHandler(peer,
          reqId, msg.request)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getBlockHeadersThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getBlockHeadersThunk_9227473515, :env)
  futureContinue(resultFuture)
  return resultFuture

proc blockBodiesThunk(peer: Peer; _`gensym85: int; data`gensym85: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator blockBodiesThunk_9227473741(chronosInternalRetFuture: FutureBase;
                                       :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym85
      var msg: blockBodiesObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.blocks = checkedRlpRead(peer, rlp, openArray[BlockBody])
      resolveResponseFuture(peer, perPeerMsgIdImpl(peer, eth67Protocol, 6),
                            addr(msg), reqId)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("blockBodiesThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (blockBodiesThunk_9227473741, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockBodiesThunk(peer: Peer; _`gensym95: int; data`gensym95: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockBodiesThunk_9227473970(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym95
      var msg: getBlockBodiesObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.hashes = checkedRlpRead(peer, rlp, openArray[Hash256])
      chronosInternalRetFuture.internalChild = getBlockBodiesUserHandler(peer,
          reqId, msg.hashes)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getBlockBodiesThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getBlockBodiesThunk_9227473970, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockThunk(peer: Peer; _`gensym102: int; data`gensym102: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockThunk_9227474044(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
      closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym102
      var msg: newBlockObj
      tryEnterList(rlp)
      msg.blk = checkedRlpRead(peer, rlp, EthBlock)
      msg.totalDifficulty = checkedRlpRead(peer, rlp, DifficultyInt)
      chronosInternalRetFuture.internalChild = newBlockUserHandler(peer,
          msg.blk, msg.totalDifficulty)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newBlockThunk", (filename: "rlpx.nim", line: 966,
        column: 8).filename, (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (newBlockThunk_9227474044, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newPooledTransactionHashesThunk(peer: Peer; _`gensym108: int;
                                     data`gensym108: Rlp): Future[void] {.
    gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator newPooledTransactionHashesThunk_9227474110(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym108
      var msg: newPooledTransactionHashesObj
      msg.txHashes = checkedRlpRead(peer, rlp, openArray[Hash256])
      chronosInternalRetFuture.internalChild = newPooledTransactionHashesUserHandler(
          peer, msg.txHashes)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("newPooledTransactionHashesThunk", (
        filename: "rlpx.nim", line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (newPooledTransactionHashesThunk_9227474110, :env)
  futureContinue(resultFuture)
  return resultFuture

proc pooledTransactionsThunk(peer: Peer; _`gensym115: int; data`gensym115: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator pooledTransactionsThunk_9227474164(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym115
      var msg: pooledTransactionsObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.transactions = checkedRlpRead(peer, rlp, openArray[Transaction])
      resolveResponseFuture(peer, perPeerMsgIdImpl(peer, eth67Protocol, 10),
                            addr(msg), reqId)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("pooledTransactionsThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (pooledTransactionsThunk_9227474164, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getPooledTransactionsThunk(peer: Peer; _`gensym125: int;
                                data`gensym125: Rlp): Future[void] {.gcsafe,
    raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getPooledTransactionsThunk_9227474238(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym125
      var msg: getPooledTransactionsObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.txHashes = checkedRlpRead(peer, rlp, openArray[Hash256])
      chronosInternalRetFuture.internalChild = getPooledTransactionsUserHandler(
          peer, reqId, msg.txHashes)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getPooledTransactionsThunk", (
        filename: "rlpx.nim", line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getPooledTransactionsThunk_9227474238, :env)
  futureContinue(resultFuture)
  return resultFuture

proc receiptsThunk(peer: Peer; _`gensym132: int; data`gensym132: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator receiptsThunk_9227474299(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
      closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym132
      var msg: receiptsObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.receipts = checkedRlpRead(peer, rlp, openArray[seq[Receipt]])
      resolveResponseFuture(peer, perPeerMsgIdImpl(peer, eth67Protocol, 16),
                            addr(msg), reqId)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("receiptsThunk", (filename: "rlpx.nim", line: 966,
        column: 8).filename, (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (receiptsThunk_9227474299, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getReceiptsThunk(peer: Peer; _`gensym142: int; data`gensym142: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getReceiptsThunk_9227474419(chronosInternalRetFuture: FutureBase;
                                       :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym142
      var msg: getReceiptsObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.hashes = checkedRlpRead(peer, rlp, openArray[Hash256])
      chronosInternalRetFuture.internalChild = getReceiptsUserHandler(peer,
          reqId, msg.hashes)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getReceiptsThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getReceiptsThunk_9227474419, :env)
  futureContinue(resultFuture)
  return resultFuture

registerMsg(eth67Protocol, 0, "status", statusThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth67Protocol, 1, "newBlockHashes", newBlockHashesThunk,
            messagePrinter, requestResolver, nextMsgResolver)
registerMsg(eth67Protocol, 2, "transactions", transactionsThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth67Protocol, 4, "blockHeaders", blockHeadersThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth67Protocol, 3, "getBlockHeaders", getBlockHeadersThunk,
            messagePrinter, requestResolver, nextMsgResolver)
registerMsg(eth67Protocol, 6, "blockBodies", blockBodiesThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth67Protocol, 5, "getBlockBodies", getBlockBodiesThunk,
            messagePrinter, requestResolver, nextMsgResolver)
registerMsg(eth67Protocol, 7, "newBlock", newBlockThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth67Protocol, 8, "newPooledTransactionHashes",
            newPooledTransactionHashesThunk, messagePrinter, requestResolver,
            nextMsgResolver)
registerMsg(eth67Protocol, 10, "pooledTransactions", pooledTransactionsThunk,
            messagePrinter, requestResolver, nextMsgResolver)
registerMsg(eth67Protocol, 9, "getPooledTransactions",
            getPooledTransactionsThunk, messagePrinter, requestResolver,
            nextMsgResolver)
registerMsg(eth67Protocol, 16, "receipts", receiptsThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(eth67Protocol, 15, "getReceipts", getReceiptsThunk, messagePrinter,
            requestResolver, nextMsgResolver)
proc eth67PeerConnected(peer: Peer): Future[void] {.gcsafe, stackTrace: false,
    gcsafe, raises: [].} =
  iterator eth67PeerConnected_9227479357(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = eth67
      template state(peer: Peer): ref[EthPeerState:ObjectType] =
        cast[ref[EthPeerState:ObjectType]](getState(peer, eth67Protocol))

      template networkState(peer: Peer): ref[EthWireBase:ObjectType] =
        cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth67Protocol))

      let
        network = peer.network
        ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
            eth67Protocol))
        status = getStatus(ctx)
      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
        except:
          discard
        {.pop.}
      let m =
        chronosInternalRetFuture.internalChild =
          let peer_9227468887 = peer
          let sendingFuture`gensym53`gensym1433 = statusRawSender(peer, 67,
              network.networkId, status.totalDifficulty, status.bestBlockHash,
              status.genesisHash, status.forkId, milliseconds(10000'i64))
          handshakeImpl(peer_9227468887, sendingFuture`gensym53`gensym1433,
                        nextMsg(peer_9227468887, statusObj), seconds(10))
        yield chronosInternalRetFuture.internalChild
        if chronosInternalRetFuture.internalMustCancel:
          raise (ref CancelledError)(msg: "Future operation cancelled!")
        internalCheckComplete(chronosInternalRetFuture.internalChild)
        internalRead(cast[type do:
          let peer_9227468887 = peer
          let sendingFuture`gensym53`gensym1433 = statusRawSender(peer, 67,
              network.networkId, status.totalDifficulty, status.bestBlockHash,
              status.genesisHash, status.forkId, milliseconds(10000'i64))
          handshakeImpl(peer_9227468887, sendingFuture`gensym53`gensym1433,
                        nextMsg(peer_9227468887, statusObj), seconds(10))](chronosInternalRetFuture.internalChild))
      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
        except:
          discard
        {.pop.}
      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
        except:
          discard
        {.pop.}
      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
        except:
          discard
        {.pop.}
      if (
        not (m.networkId == network.networkId)):
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
          except:
            discard
          {.pop.}
        raise
          (ref UselessPeerError)(msg: "Eth handshake for different network",
                                 parent: nil)
      if (
        not (m.genesisHash == status.genesisHash)):
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
          except:
            discard
          {.pop.}
        raise
          (ref UselessPeerError)(msg: "Eth handshake for different network",
                                 parent: nil)
      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
        except:
          discard
        {.pop.}
      cast[ref[EthPeerState:ObjectType]](getState(peer, eth67Protocol)).initialized = true
      cast[ref[EthPeerState:ObjectType]](getState(peer, eth67Protocol)).bestDifficulty = m.totalDifficulty
      cast[ref[EthPeerState:ObjectType]](getState(peer, eth67Protocol)).bestBlockHash = m.bestHash
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth67.nim", line: 86, column: 4).filename,
        (filename: "eth67.nim", line: 86, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("eth67PeerConnected", (filename: "eth67.nim",
        line: 86, column: 4).filename,
                             (filename: "eth67.nim", line: 86, column: 4).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (eth67PeerConnected_9227479357, :env)
  futureContinue(resultFuture)
  return resultFuture

setEventHandlers(eth67Protocol, eth67PeerConnected, nil)
registerProtocol(eth67Protocol)