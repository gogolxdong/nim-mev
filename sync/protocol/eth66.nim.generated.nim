
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

template status(peer: Peer; ethVersionArg: uint; networkId: NetworkId;
                totalDifficulty: DifficultyInt; bestHash: Hash256;
                genesisHash: Hash256; forkId: ChainForkId;
                timeout: Duration = milliseconds(10000'i64)): Future[statusObj] =
  let peer_8942256216 = peer
  let sendingFuture`gensym61_8942256852 = statusRawSender(peer, ethVersionArg,
      networkId, totalDifficulty, bestHash, genesisHash, forkId)
  handshakeImpl(peer_8942256216, sendingFuture`gensym61_8942256852,
                nextMsg(peer_8942256216, statusObj), timeout)

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
      loc`gensym236 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym236 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
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
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 2)
  appendInt(writer, perPeerMsgId)
  append(writer, transactions)
  let msgBytes =
    const
      loc`gensym243 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym243 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
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
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 4)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendInt(writer, peerOrResponder.reqId)
  appendImpl(writer, headers)
  let msgBytes =
    const
      loc`gensym252 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym252 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
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
      loc`gensym285 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym285 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
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
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 6)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendInt(writer, peerOrResponder.reqId)
  appendImpl(writer, blocks)
  let msgBytes =
    const
      loc`gensym321 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym321 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
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
      loc`gensym332 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym332 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
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
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 7)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendImpl(writer, blk)
  append(writer, totalDifficulty)
  let msgBytes =
    const
      loc`gensym366 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym366 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
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
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 8)
  appendInt(writer, perPeerMsgId)
  appendImpl(writer, txHashes)
  let msgBytes =
    const
      loc`gensym373 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym373 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
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
  let perPeerMsgId = perPeerMsgIdImpl(peer, eth66Protocol, 10)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendInt(writer, peerOrResponder.reqId)
  append(writer, transactions)
  let msgBytes =
    const
      loc`gensym381 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym381 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
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
      loc`gensym392 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym392 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
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
      loc`gensym401 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym401 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
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
      loc`gensym409 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym409 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
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
      loc`gensym419 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym419 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
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
      loc`gensym430 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym430 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
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
  iterator statusUserHandler_8942259427(chronosInternalRetFuture: FutureBase;
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
          if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
            break chroniclesLogStmt
          var record_8942259466:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_8942259466 = default(typeof(record_8942259466))
          if {.gcsafe.}:
            addr defaultChroniclesStreamOutputs
          [][0].outFile ==
              nil:
            openOutput( {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0])
          initLogRecord(record_8942259466, LogLevel(3), "eth66",
                        "<< [eth/66] Received Status (0x00)")
          setProperty(record_8942259466, "tid", getLogThreadId())
          setProperty(record_8942259466, "file", "eth66.nim:142")
          mixin setProperty, formatItIMPL
          setProperty(record_8942259466, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_8942259466, "networkId", networkId)
          mixin setProperty, formatItIMPL
          setProperty(record_8942259466, "totalDifficulty", totalDifficulty)
          mixin setProperty, formatItIMPL
          setProperty(record_8942259466, "bestHash", short(bestHash))
          mixin setProperty, formatItIMPL
          setProperty(record_8942259466, "genesisHash", short(genesisHash))
          mixin setProperty, formatItIMPL
          setProperty(record_8942259466, "forkHash", toHex(forkId.forkHash))
          mixin setProperty, formatItIMPL
          setProperty(record_8942259466, "forkNext", forkId.forkNext)
          logAllDynamicProperties(
            defaultChroniclesStream, record_8942259466)
          flushRecord(record_8942259466)
      except CatchableError as err`gensym444:
        logLoggingFailure(cstring("<< [eth/66] Received Status (0x00)"),
                          err`gensym444)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 142, column: 6).filename,
        (filename: "eth66.nim", line: 142, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("statusUserHandler", (filename: "eth66.nim",
        line: 142, column: 6).filename, (filename: "eth66.nim", line: 142,
        column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (statusUserHandler_8942259427, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockHashesUserHandler(peer: Peer; hashes: seq[NewBlockHashesAnnounce]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockHashesUserHandler_8942259682(
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
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (newBlockHashesUserHandler_8942259682, :env)
  futureContinue(resultFuture)
  return resultFuture

proc transactionsUserHandler(peer: Peer; transactions: seq[Transaction]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator transactionsUserHandler_8942259745(
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
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (transactionsUserHandler_8942259745, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockHeadersUserHandler(peer: Peer; reqId: int; request: BlocksRequest): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockHeadersUserHandler_8942259790(
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
          if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
            break chroniclesLogStmt
          var record_8942259843:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_8942259843 = default(typeof(record_8942259843))
          if {.gcsafe.}:
            addr defaultChroniclesStreamOutputs
          [][0].outFile ==
              nil:
            openOutput( {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0])
          initLogRecord(record_8942259843, LogLevel(3), "eth66",
                        "<< [eth/66] Received GetBlockHeaders (0x03)")
          setProperty(record_8942259843, "tid", getLogThreadId())
          setProperty(record_8942259843, "file", "eth66.nim:168")
          mixin setProperty, formatItIMPL
          setProperty(record_8942259843, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_8942259843, "count", request.maxResults)
          logAllDynamicProperties(
            defaultChroniclesStream, record_8942259843)
          flushRecord(record_8942259843)
      except CatchableError as err`gensym509:
        logLoggingFailure(cstring("<< [eth/66] Received GetBlockHeaders (0x03)"),
                          err`gensym509)
      if (
        uint64(192) < request.maxResults):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            if not topicsMatch(LogLevel(2), [topicStateIMPL("eth66")]):
              break chroniclesLogStmt
            var record_8942259937:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_8942259937 = default(typeof(record_8942259937))
            if {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0].outFile ==
                nil:
              openOutput( {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0])
            initLogRecord(record_8942259937, LogLevel(2), "eth66",
                          "GetBlockHeaders (0x03) requested too many headers")
            setProperty(record_8942259937, "tid", getLogThreadId())
            setProperty(record_8942259937, "file", "eth66.nim:172")
            mixin setProperty, formatItIMPL
            setProperty(record_8942259937, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_8942259937, "requested", request.maxResults)
            mixin setProperty, formatItIMPL
            setProperty(record_8942259937, "max", 192)
            logAllDynamicProperties(
              defaultChroniclesStream, record_8942259937)
            flushRecord(record_8942259937)
        except CatchableError as err`gensym530:
          logLoggingFailure(cstring("GetBlockHeaders (0x03) requested too many headers"),
                            err`gensym530)
        chronosInternalRetFuture.internalChild = disconnect(peer,
            BreachOfProtocol, false)
        yield chronosInternalRetFuture.internalChild
        if chronosInternalRetFuture.internalMustCancel:
          raise (ref CancelledError)(msg: "Future operation cancelled!")
        internalCheckComplete(chronosInternalRetFuture.internalChild)
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
            if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
              break chroniclesLogStmt
            var record_8942260063:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_8942260063 = default(typeof(record_8942260063))
            if {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0].outFile ==
                nil:
              openOutput( {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0])
            initLogRecord(record_8942260063, LogLevel(3), "eth66",
                          ">> [eth/66] Replying with BlockHeaders (0x04)")
            setProperty(record_8942260063, "tid", getLogThreadId())
            setProperty(record_8942260063, "file", "eth66.nim:180")
            mixin setProperty, formatItIMPL
            setProperty(record_8942260063, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_8942260063, "sent", len(headers))
            mixin setProperty, formatItIMPL
            setProperty(record_8942260063, "requested", request.maxResults)
            logAllDynamicProperties(
              defaultChroniclesStream, record_8942260063)
            flushRecord(record_8942260063)
        except CatchableError as err`gensym559:
          logLoggingFailure(cstring(">> [eth/66] Replying with BlockHeaders (0x04)"),
                            err`gensym559)
      else:
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
              break chroniclesLogStmt
            var record_8942260170:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_8942260170 = default(typeof(record_8942260170))
            if {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0].outFile ==
                nil:
              openOutput( {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0])
            initLogRecord(record_8942260170, LogLevel(3), "eth66",
                          ">> [eth/66] Replying EMPTY BlockHeaders (0x04)")
            setProperty(record_8942260170, "tid", getLogThreadId())
            setProperty(record_8942260170, "file", "eth66.nim:183")
            mixin setProperty, formatItIMPL
            setProperty(record_8942260170, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_8942260170, "sent", 0)
            mixin setProperty, formatItIMPL
            setProperty(record_8942260170, "requested", request.maxResults)
            logAllDynamicProperties(
              defaultChroniclesStream, record_8942260170)
            flushRecord(record_8942260170)
        except CatchableError as err`gensym581:
          logLoggingFailure(cstring(">> [eth/66] Replying EMPTY BlockHeaders (0x04)"),
                            err`gensym581)
      chronosInternalRetFuture.internalChild = blockHeaders(response, headers)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 167, column: 6).filename,
        (filename: "eth66.nim", line: 167, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getBlockHeadersUserHandler", (
        filename: "eth66.nim", line: 167, column: 6).filename, (
        filename: "eth66.nim", line: 167, column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getBlockHeadersUserHandler_8942259790, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockBodiesUserHandler(peer: Peer; reqId: int; hashes: seq[Hash256]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockBodiesUserHandler_8942260285(
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
          if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
            break chroniclesLogStmt
          var record_8942260329:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_8942260329 = default(typeof(record_8942260329))
          if {.gcsafe.}:
            addr defaultChroniclesStreamOutputs
          [][0].outFile ==
              nil:
            openOutput( {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0])
          initLogRecord(record_8942260329, LogLevel(3), "eth66",
                        "<< [eth/66] Received GetBlockBodies (0x05)")
          setProperty(record_8942260329, "tid", getLogThreadId())
          setProperty(record_8942260329, "file", "eth66.nim:194")
          mixin setProperty, formatItIMPL
          setProperty(record_8942260329, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_8942260329, "hashes", len(hashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_8942260329)
          flushRecord(record_8942260329)
      except CatchableError as err`gensym614:
        logLoggingFailure(cstring("<< [eth/66] Received GetBlockBodies (0x05)"),
                          err`gensym614)
      if (
        128 < len(hashes)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            if not topicsMatch(LogLevel(2), [topicStateIMPL("eth66")]):
              break chroniclesLogStmt
            var record_8942260432:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_8942260432 = default(typeof(record_8942260432))
            if {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0].outFile ==
                nil:
              openOutput( {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0])
            initLogRecord(record_8942260432, LogLevel(2), "eth66",
                          "GetBlockBodies (0x05) requested too many bodies")
            setProperty(record_8942260432, "tid", getLogThreadId())
            setProperty(record_8942260432, "file", "eth66.nim:197")
            mixin setProperty, formatItIMPL
            setProperty(record_8942260432, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_8942260432, "requested", len(hashes))
            mixin setProperty, formatItIMPL
            setProperty(record_8942260432, "max", 128)
            logAllDynamicProperties(
              defaultChroniclesStream, record_8942260432)
            flushRecord(record_8942260432)
        except CatchableError as err`gensym635:
          logLoggingFailure(cstring("GetBlockBodies (0x05) requested too many bodies"),
                            err`gensym635)
        chronosInternalRetFuture.internalChild = disconnect(peer,
            BreachOfProtocol, false)
        yield chronosInternalRetFuture.internalChild
        if chronosInternalRetFuture.internalMustCancel:
          raise (ref CancelledError)(msg: "Future operation cancelled!")
        internalCheckComplete(chronosInternalRetFuture.internalChild)
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
            if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
              break chroniclesLogStmt
            var record_8942260562:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_8942260562 = default(typeof(record_8942260562))
            if {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0].outFile ==
                nil:
              openOutput( {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0])
            initLogRecord(record_8942260562, LogLevel(3), "eth66",
                          ">> [eth/66] Replying with BlockBodies (0x06)")
            setProperty(record_8942260562, "tid", getLogThreadId())
            setProperty(record_8942260562, "file", "eth66.nim:205")
            mixin setProperty, formatItIMPL
            setProperty(record_8942260562, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_8942260562, "sent", len(bodies))
            mixin setProperty, formatItIMPL
            setProperty(record_8942260562, "requested", len(hashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_8942260562)
            flushRecord(record_8942260562)
        except CatchableError as err`gensym664:
          logLoggingFailure(cstring(">> [eth/66] Replying with BlockBodies (0x06)"),
                            err`gensym664)
      else:
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
              break chroniclesLogStmt
            var record_8942260672:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_8942260672 = default(typeof(record_8942260672))
            if {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0].outFile ==
                nil:
              openOutput( {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0])
            initLogRecord(record_8942260672, LogLevel(3), "eth66",
                          ">> [eth/66] Replying EMPTY BlockBodies (0x06)")
            setProperty(record_8942260672, "tid", getLogThreadId())
            setProperty(record_8942260672, "file", "eth66.nim:208")
            mixin setProperty, formatItIMPL
            setProperty(record_8942260672, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_8942260672, "sent", 0)
            mixin setProperty, formatItIMPL
            setProperty(record_8942260672, "requested", len(hashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_8942260672)
            flushRecord(record_8942260672)
        except CatchableError as err`gensym686:
          logLoggingFailure(cstring(">> [eth/66] Replying EMPTY BlockBodies (0x06)"),
                            err`gensym686)
      chronosInternalRetFuture.internalChild = blockBodies(response, bodies)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 194, column: 6).filename,
        (filename: "eth66.nim", line: 194, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getBlockBodiesUserHandler", (
        filename: "eth66.nim", line: 194, column: 6).filename, (
        filename: "eth66.nim", line: 194, column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getBlockBodiesUserHandler_8942260285, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockUserHandler(peer: Peer; blk: EthBlock;
                         totalDifficulty: DifficultyInt): Future[void] {.gcsafe,
    stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockUserHandler_8942260799(chronosInternalRetFuture: FutureBase;
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
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (newBlockUserHandler_8942260799, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newPooledTransactionHashesUserHandler(peer: Peer; txHashes: seq[Hash256]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator newPooledTransactionHashesUserHandler_8942260845(
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
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (newPooledTransactionHashesUserHandler_8942260845, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getPooledTransactionsUserHandler(peer: Peer; reqId: int;
                                      txHashes: seq[Hash256]): Future[void] {.
    gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getPooledTransactionsUserHandler_8942260890(
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
          if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
            break chroniclesLogStmt
          var record_8942260934:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_8942260934 = default(typeof(record_8942260934))
          if {.gcsafe.}:
            addr defaultChroniclesStreamOutputs
          [][0].outFile ==
              nil:
            openOutput( {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0])
          initLogRecord(record_8942260934, LogLevel(3), "eth66",
                        "<< [eth/66] Received GetPooledTransactions (0x09)")
          setProperty(record_8942260934, "tid", getLogThreadId())
          setProperty(record_8942260934, "file", "eth66.nim:241")
          mixin setProperty, formatItIMPL
          setProperty(record_8942260934, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_8942260934, "hashes", len(txHashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_8942260934)
          flushRecord(record_8942260934)
      except CatchableError as err`gensym735:
        logLoggingFailure(cstring("<< [eth/66] Received GetPooledTransactions (0x09)"),
                          err`gensym735)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      let txs = getPooledTxs(ctx, txHashes)
      if (
        0 < len(txs)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
              break chroniclesLogStmt
            var record_8942261039:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_8942261039 = default(typeof(record_8942261039))
            if {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0].outFile ==
                nil:
              openOutput( {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0])
            initLogRecord(record_8942261039, LogLevel(3), "eth66",
                          ">> [eth/66] Replying with PooledTransactions (0x0a)")
            setProperty(record_8942261039, "tid", getLogThreadId())
            setProperty(record_8942261039, "file", "eth66.nim:247")
            mixin setProperty, formatItIMPL
            setProperty(record_8942261039, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_8942261039, "sent", len(txs))
            mixin setProperty, formatItIMPL
            setProperty(record_8942261039, "requested", len(txHashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_8942261039)
            flushRecord(record_8942261039)
        except CatchableError as err`gensym757:
          logLoggingFailure(cstring(">> [eth/66] Replying with PooledTransactions (0x0a)"),
                            err`gensym757)
      else:
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
              break chroniclesLogStmt
            var record_8942261149:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_8942261149 = default(typeof(record_8942261149))
            if {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0].outFile ==
                nil:
              openOutput( {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0])
            initLogRecord(record_8942261149, LogLevel(3), "eth66", ">> [eth/66] Replying EMPTY PooledTransactions (0x0a)")
            setProperty(record_8942261149, "tid", getLogThreadId())
            setProperty(record_8942261149, "file", "eth66.nim:250")
            mixin setProperty, formatItIMPL
            setProperty(record_8942261149, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_8942261149, "sent", 0)
            mixin setProperty, formatItIMPL
            setProperty(record_8942261149, "requested", len(txHashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_8942261149)
            flushRecord(record_8942261149)
        except CatchableError as err`gensym779:
          logLoggingFailure(cstring(">> [eth/66] Replying EMPTY PooledTransactions (0x0a)"),
                            err`gensym779)
      chronosInternalRetFuture.internalChild = pooledTransactions(response, txs)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 241, column: 6).filename,
        (filename: "eth66.nim", line: 241, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getPooledTransactionsUserHandler", (
        filename: "eth66.nim", line: 241, column: 6).filename, (
        filename: "eth66.nim", line: 241, column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getPooledTransactionsUserHandler_8942260890, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getNodeDataUserHandler(peer: Peer; nodeHashes: seq[Hash256]): Future[void] {.
    gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getNodeDataUserHandler_8942261267(
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
          if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
            break chroniclesLogStmt
          var record_8942261301:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_8942261301 = default(typeof(record_8942261301))
          if {.gcsafe.}:
            addr defaultChroniclesStreamOutputs
          [][0].outFile ==
              nil:
            openOutput( {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0])
          initLogRecord(record_8942261301, LogLevel(3), "eth66",
                        "<< [eth/66] Received GetNodeData (0x0d)")
          setProperty(record_8942261301, "tid", getLogThreadId())
          setProperty(record_8942261301, "file", "eth66.nim:262")
          mixin setProperty, formatItIMPL
          setProperty(record_8942261301, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_8942261301, "hashes", len(nodeHashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_8942261301)
          flushRecord(record_8942261301)
      except CatchableError as err`gensym812:
        logLoggingFailure(cstring("<< [eth/66] Received GetNodeData (0x0d)"),
                          err`gensym812)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      let data = getStorageNodes(ctx, nodeHashes)
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
            break chroniclesLogStmt
          var record_8942261400:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_8942261400 = default(typeof(record_8942261400))
          if {.gcsafe.}:
            addr defaultChroniclesStreamOutputs
          [][0].outFile ==
              nil:
            openOutput( {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0])
          initLogRecord(record_8942261400, LogLevel(3), "eth66",
                        ">> [eth/66] Replying NodeData (0x0e)")
          setProperty(record_8942261400, "tid", getLogThreadId())
          setProperty(record_8942261400, "file", "eth66.nim:268")
          mixin setProperty, formatItIMPL
          setProperty(record_8942261400, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_8942261400, "sent", len(data))
          mixin setProperty, formatItIMPL
          setProperty(record_8942261400, "requested", len(nodeHashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_8942261400)
          flushRecord(record_8942261400)
      except CatchableError as err`gensym833:
        logLoggingFailure(cstring(">> [eth/66] Replying NodeData (0x0e)"),
                          err`gensym833)
      chronosInternalRetFuture.internalChild = nodeData(peer, data)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 262, column: 4).filename,
        (filename: "eth66.nim", line: 262, column: 4).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getNodeDataUserHandler", (filename: "eth66.nim",
        line: 262, column: 4).filename, (filename: "eth66.nim", line: 262,
        column: 4).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getNodeDataUserHandler_8942261267, :env)
  futureContinue(resultFuture)
  return resultFuture

proc nodeDataUserHandler(peer: Peer; data: seq[Blob]): Future[void] {.gcsafe,
    stackTrace: false, gcsafe, raises: [].} =
  iterator nodeDataUserHandler_8942261530(chronosInternalRetFuture: FutureBase;
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
          if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
            break chroniclesLogStmt
          var record_8942261564:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_8942261564 = default(typeof(record_8942261564))
          if {.gcsafe.}:
            addr defaultChroniclesStreamOutputs
          [][0].outFile ==
              nil:
            openOutput( {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0])
          initLogRecord(record_8942261564, LogLevel(3), "eth66",
                        "<< [eth/66] Received NodeData (0x0e)")
          setProperty(record_8942261564, "tid", getLogThreadId())
          setProperty(record_8942261564, "file", "eth66.nim:275")
          mixin setProperty, formatItIMPL
          setProperty(record_8942261564, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_8942261564, "bytes", len(data))
          logAllDynamicProperties(
            defaultChroniclesStream, record_8942261564)
          flushRecord(record_8942261564)
      except CatchableError as err`gensym865:
        logLoggingFailure(cstring("<< [eth/66] Received NodeData (0x0e)"),
                          err`gensym865)
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
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (nodeDataUserHandler_8942261530, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getReceiptsUserHandler(peer: Peer; reqId: int; hashes: seq[Hash256]): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getReceiptsUserHandler_8942261672(
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
          if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
            break chroniclesLogStmt
          var record_8942261716:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_8942261716 = default(typeof(record_8942261716))
          if {.gcsafe.}:
            addr defaultChroniclesStreamOutputs
          [][0].outFile ==
              nil:
            openOutput( {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0])
          initLogRecord(record_8942261716, LogLevel(3), "eth66",
                        "<< [eth/66] Received GetReceipts (0x0f)")
          setProperty(record_8942261716, "tid", getLogThreadId())
          setProperty(record_8942261716, "file", "eth66.nim:283")
          mixin setProperty, formatItIMPL
          setProperty(record_8942261716, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_8942261716, "hashes", len(hashes))
          logAllDynamicProperties(
            defaultChroniclesStream, record_8942261716)
          flushRecord(record_8942261716)
      except CatchableError as err`gensym893:
        logLoggingFailure(cstring("<< [eth/66] Received GetReceipts (0x0f)"),
                          err`gensym893)
      let ctx = cast[ref[EthWireBase:ObjectType]](getNetworkState(peer.network,
          eth66Protocol))
      let rec = getReceipts(ctx, hashes)
      if (
        0 < len(rec)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
              break chroniclesLogStmt
            var record_8942261822:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_8942261822 = default(typeof(record_8942261822))
            if {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0].outFile ==
                nil:
              openOutput( {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0])
            initLogRecord(record_8942261822, LogLevel(3), "eth66",
                          ">> [eth/66] Replying with Receipts (0x10)")
            setProperty(record_8942261822, "tid", getLogThreadId())
            setProperty(record_8942261822, "file", "eth66.nim:289")
            mixin setProperty, formatItIMPL
            setProperty(record_8942261822, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_8942261822, "sent", len(rec))
            mixin setProperty, formatItIMPL
            setProperty(record_8942261822, "requested", len(hashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_8942261822)
            flushRecord(record_8942261822)
        except CatchableError as err`gensym915:
          logLoggingFailure(cstring(">> [eth/66] Replying with Receipts (0x10)"),
                            err`gensym915)
      else:
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
              break chroniclesLogStmt
            var record_8942261932:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_8942261932 = default(typeof(record_8942261932))
            if {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0].outFile ==
                nil:
              openOutput( {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0])
            initLogRecord(record_8942261932, LogLevel(3), "eth66",
                          ">> [eth/66] Replying EMPTY Receipts (0x10)")
            setProperty(record_8942261932, "tid", getLogThreadId())
            setProperty(record_8942261932, "file", "eth66.nim:292")
            mixin setProperty, formatItIMPL
            setProperty(record_8942261932, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_8942261932, "sent", 0)
            mixin setProperty, formatItIMPL
            setProperty(record_8942261932, "requested", len(hashes))
            logAllDynamicProperties(
              defaultChroniclesStream, record_8942261932)
            flushRecord(record_8942261932)
        except CatchableError as err`gensym937:
          logLoggingFailure(cstring(">> [eth/66] Replying EMPTY Receipts (0x10)"),
                            err`gensym937)
      chronosInternalRetFuture.internalChild = receipts(response, rec)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "eth66.nim", line: 283, column: 6).filename,
        (filename: "eth66.nim", line: 283, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getReceiptsUserHandler", (filename: "eth66.nim",
        line: 283, column: 6).filename, (filename: "eth66.nim", line: 283,
        column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getReceiptsUserHandler_8942261672, :env)
  futureContinue(resultFuture)
  return resultFuture

proc statusThunk(peer: Peer; _`gensym56: int; data`gensym56: Rlp): Future[void] {.
    gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator statusThunk_8942262068(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
      closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym56
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
    (statusThunk_8942262068, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockHashesThunk(peer: Peer; _`gensym63: int; data`gensym63: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockHashesThunk_8942262420(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym63
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
    (newBlockHashesThunk_8942262420, :env)
  futureContinue(resultFuture)
  return resultFuture

proc transactionsThunk(peer: Peer; _`gensym69: int; data`gensym69: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator transactionsThunk_8942262593(chronosInternalRetFuture: FutureBase;
                                        :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym69
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
    (transactionsThunk_8942262593, :env)
  futureContinue(resultFuture)
  return resultFuture

proc blockHeadersThunk(peer: Peer; _`gensym76: int; data`gensym76: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator blockHeadersThunk_8942262667(chronosInternalRetFuture: FutureBase;
                                        :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym76
      var msg: blockHeadersObj
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
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (blockHeadersThunk_8942262667, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockHeadersThunk(peer: Peer; _`gensym86: int; data`gensym86: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockHeadersThunk_8942262754(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym86
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
    (getBlockHeadersThunk_8942262754, :env)
  futureContinue(resultFuture)
  return resultFuture

proc blockBodiesThunk(peer: Peer; _`gensym93: int; data`gensym93: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator blockBodiesThunk_8942262980(chronosInternalRetFuture: FutureBase;
                                       :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym93
      var msg: blockBodiesObj
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
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (blockBodiesThunk_8942262980, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getBlockBodiesThunk(peer: Peer; _`gensym103: int; data`gensym103: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getBlockBodiesThunk_8942263210(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym103
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
    (getBlockBodiesThunk_8942263210, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newBlockThunk(peer: Peer; _`gensym110: int; data`gensym110: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator newBlockThunk_8942263284(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
      closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym110
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
    (newBlockThunk_8942263284, :env)
  futureContinue(resultFuture)
  return resultFuture

proc newPooledTransactionHashesThunk(peer: Peer; _`gensym116: int;
                                     data`gensym116: Rlp): Future[void] {.
    gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator newPooledTransactionHashesThunk_8942263350(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym116
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
    (newPooledTransactionHashesThunk_8942263350, :env)
  futureContinue(resultFuture)
  return resultFuture

proc pooledTransactionsThunk(peer: Peer; _`gensym123: int; data`gensym123: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator pooledTransactionsThunk_8942263404(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym123
      var msg: pooledTransactionsObj
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
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (pooledTransactionsThunk_8942263404, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getPooledTransactionsThunk(peer: Peer; _`gensym133: int;
                                data`gensym133: Rlp): Future[void] {.gcsafe,
    raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getPooledTransactionsThunk_8942263478(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym133
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
    (getPooledTransactionsThunk_8942263478, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getNodeDataThunk(peer: Peer; _`gensym139: int; data`gensym139: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getNodeDataThunk_8942263539(chronosInternalRetFuture: FutureBase;
                                       :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym139
      var msg: getNodeDataObj
      msg.nodeHashes = checkedRlpRead(peer, rlp, openArray[Hash256])
      chronosInternalRetFuture.internalChild = getNodeDataUserHandler(peer,
          msg.nodeHashes)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getNodeDataThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getNodeDataThunk_8942263539, :env)
  futureContinue(resultFuture)
  return resultFuture

proc nodeDataThunk(peer: Peer; _`gensym145: int; data`gensym145: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator nodeDataThunk_8942263593(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
      closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym145
      var msg: nodeDataObj
      msg.data = checkedRlpRead(peer, rlp, openArray[Blob])
      chronosInternalRetFuture.internalChild = nodeDataUserHandler(peer,
          msg.data)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("nodeDataThunk", (filename: "rlpx.nim", line: 966,
        column: 8).filename, (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (nodeDataThunk_8942263593, :env)
  futureContinue(resultFuture)
  return resultFuture

proc receiptsThunk(peer: Peer; _`gensym152: int; data`gensym152: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator receiptsThunk_8942263678(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
      closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym152
      var msg: receiptsObj
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
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (receiptsThunk_8942263678, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getReceiptsThunk(peer: Peer; _`gensym162: int; data`gensym162: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getReceiptsThunk_8942263799(chronosInternalRetFuture: FutureBase;
                                       :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym162
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
    (getReceiptsThunk_8942263799, :env)
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
  iterator eth66PeerConnected_8942273579(chronosInternalRetFuture: FutureBase;
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
          if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
            break chroniclesLogStmt
          var record_8942273614:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_8942273614 = default(typeof(record_8942273614))
          if {.gcsafe.}:
            addr defaultChroniclesStreamOutputs
          [][0].outFile ==
              nil:
            openOutput( {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0])
          initLogRecord(record_8942273614, LogLevel(3), "eth66",
                        ">> [eth/66] Sending Status (0x00)")
          setProperty(record_8942273614, "tid", getLogThreadId())
          setProperty(record_8942273614, "file", "eth66.nim:91")
          mixin setProperty, formatItIMPL
          setProperty(record_8942273614, "peer", $peer.remote)
          mixin setProperty, formatItIMPL
          setProperty(record_8942273614, "td", status.totalDifficulty)
          mixin setProperty, formatItIMPL
          setProperty(record_8942273614, "bestHash", short(status.bestBlockHash))
          mixin setProperty, formatItIMPL
          setProperty(record_8942273614, "networkId", network.networkId)
          mixin setProperty, formatItIMPL
          setProperty(record_8942273614, "genesis", short(status.genesisHash))
          mixin setProperty, formatItIMPL
          setProperty(record_8942273614, "forkHash",
                      toHex(status.forkId.forkHash))
          mixin setProperty, formatItIMPL
          setProperty(record_8942273614, "forkNext", status.forkId.forkNext)
          logAllDynamicProperties(
            defaultChroniclesStream, record_8942273614)
          flushRecord(record_8942273614)
      except CatchableError as err`gensym2678:
        logLoggingFailure(cstring(">> [eth/66] Sending Status (0x00)"),
                          err`gensym2678)
      let m =
        chronosInternalRetFuture.internalChild =
          let peer_8942256216 = peer
          let sendingFuture`gensym61`gensym2700 = statusRawSender(peer, 66,
              network.networkId, status.totalDifficulty, status.bestBlockHash,
              status.genesisHash, status.forkId, milliseconds(10000'i64))
          handshakeImpl(peer_8942256216, sendingFuture`gensym61`gensym2700,
                        nextMsg(peer_8942256216, statusObj), seconds(10))
        yield chronosInternalRetFuture.internalChild
        if chronosInternalRetFuture.internalMustCancel:
          raise (ref CancelledError)(msg: "Future operation cancelled!")
        internalCheckComplete(chronosInternalRetFuture.internalChild)
        internalRead(cast[type do:
          let peer_8942256216 = peer
          let sendingFuture`gensym61`gensym2700 = statusRawSender(peer, 66,
              network.networkId, status.totalDifficulty, status.bestBlockHash,
              status.genesisHash, status.forkId, milliseconds(10000'i64))
          handshakeImpl(peer_8942256216, sendingFuture`gensym61`gensym2700,
                        nextMsg(peer_8942256216, statusObj), seconds(10))](chronosInternalRetFuture.internalChild))
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
            break chroniclesLogStmt
          var record_8942274241:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_8942274241 = default(typeof(record_8942274241))
          if {.gcsafe.}:
            addr defaultChroniclesStreamOutputs
          [][0].outFile ==
              nil:
            openOutput( {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0])
          initLogRecord(record_8942274241, LogLevel(3), "eth66",
                        "Handshake: Local and remote networkId")
          setProperty(record_8942274241, "tid", getLogThreadId())
          setProperty(record_8942274241, "file", "eth66.nim:108")
          mixin setProperty, formatItIMPL
          setProperty(record_8942274241, "local", network.networkId)
          mixin setProperty, formatItIMPL
          setProperty(record_8942274241, "remote", m.networkId)
          logAllDynamicProperties(
            defaultChroniclesStream, record_8942274241)
          flushRecord(record_8942274241)
      except CatchableError as err`gensym2789:
        logLoggingFailure(cstring("Handshake: Local and remote networkId"),
                          err`gensym2789)
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
            break chroniclesLogStmt
          var record_8942274336:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_8942274336 = default(typeof(record_8942274336))
          if {.gcsafe.}:
            addr defaultChroniclesStreamOutputs
          [][0].outFile ==
              nil:
            openOutput( {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0])
          initLogRecord(record_8942274336, LogLevel(3), "eth66",
                        "Handshake: Local and remote genesisHash")
          setProperty(record_8942274336, "tid", getLogThreadId())
          setProperty(record_8942274336, "file", "eth66.nim:110")
          mixin setProperty, formatItIMPL
          setProperty(record_8942274336, "local", status.genesisHash)
          mixin setProperty, formatItIMPL
          setProperty(record_8942274336, "remote", m.genesisHash)
          logAllDynamicProperties(
            defaultChroniclesStream, record_8942274336)
          flushRecord(record_8942274336)
      except CatchableError as err`gensym2809:
        logLoggingFailure(cstring("Handshake: Local and remote genesisHash"),
                          err`gensym2809)
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
            break chroniclesLogStmt
          var record_8942274431:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_8942274431 = default(typeof(record_8942274431))
          if {.gcsafe.}:
            addr defaultChroniclesStreamOutputs
          [][0].outFile ==
              nil:
            openOutput( {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0])
          initLogRecord(record_8942274431, LogLevel(3), "eth66",
                        "Handshake: Local and remote forkId")
          setProperty(record_8942274431, "tid", getLogThreadId())
          setProperty(record_8942274431, "file", "eth66.nim:112")
          mixin setProperty, formatItIMPL
          setProperty(record_8942274431, "local", toHex(status.forkId.forkHash) &
              "/" &
              $status.forkId.forkNext)
          mixin setProperty, formatItIMPL
          setProperty(record_8942274431, "remote",
                      toHex(m.forkId.forkHash) & "/" & $m.forkId.forkNext)
          logAllDynamicProperties(
            defaultChroniclesStream, record_8942274431)
          flushRecord(record_8942274431)
      except CatchableError as err`gensym2829:
        logLoggingFailure(cstring("Handshake: Local and remote forkId"),
                          err`gensym2829)
      if (
        not (m.networkId == network.networkId)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
              break chroniclesLogStmt
            var record_8942274702:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_8942274702 = default(typeof(record_8942274702))
            if {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0].outFile ==
                nil:
              openOutput( {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0])
            initLogRecord(record_8942274702, LogLevel(3), "eth66",
                          "Peer for a different network (networkId)")
            setProperty(record_8942274702, "tid", getLogThreadId())
            setProperty(record_8942274702, "file", "eth66.nim:117")
            mixin setProperty, formatItIMPL
            setProperty(record_8942274702, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_8942274702, "expectNetworkId", network.networkId)
            mixin setProperty, formatItIMPL
            setProperty(record_8942274702, "gotNetworkId", m.networkId)
            logAllDynamicProperties(
              defaultChroniclesStream, record_8942274702)
            flushRecord(record_8942274702)
        except CatchableError as err`gensym2850:
          logLoggingFailure(cstring("Peer for a different network (networkId)"),
                            err`gensym2850)
        raise
          (ref UselessPeerError)(msg: "Eth handshake for different network",
                                 parent: nil)
      if (
        not (m.genesisHash == status.genesisHash)):
        bind logIMPL, bindSym, brForceOpen
        try:
          block chroniclesLogStmt:
            if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
              break chroniclesLogStmt
            var record_8942274906:
              defaultChroniclesStreamLogRecord
            mixin activateOutput
            record_8942274906 = default(typeof(record_8942274906))
            if {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0].outFile ==
                nil:
              openOutput( {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0])
            initLogRecord(record_8942274906, LogLevel(3), "eth66",
                          "Peer for a different network (genesisHash)")
            setProperty(record_8942274906, "tid", getLogThreadId())
            setProperty(record_8942274906, "file", "eth66.nim:123")
            mixin setProperty, formatItIMPL
            setProperty(record_8942274906, "peer", $peer.remote)
            mixin setProperty, formatItIMPL
            setProperty(record_8942274906, "expectGenesis",
                        short(status.genesisHash))
            mixin setProperty, formatItIMPL
            setProperty(record_8942274906, "gotGenesis", short(m.genesisHash))
            logAllDynamicProperties(
              defaultChroniclesStream, record_8942274906)
            flushRecord(record_8942274906)
        except CatchableError as err`gensym2874:
          logLoggingFailure(cstring("Peer for a different network (genesisHash)"),
                            err`gensym2874)
        raise
          (ref UselessPeerError)(msg: "Eth handshake for different network",
                                 parent: nil)
      bind logIMPL, bindSym, brForceOpen
      try:
        block chroniclesLogStmt:
          if not topicsMatch(LogLevel(3), [topicStateIMPL("eth66")]):
            break chroniclesLogStmt
          var record_8942275011:
            defaultChroniclesStreamLogRecord
          mixin activateOutput
          record_8942275011 = default(typeof(record_8942275011))
          if {.gcsafe.}:
            addr defaultChroniclesStreamOutputs
          [][0].outFile ==
              nil:
            openOutput( {.gcsafe.}:
              addr defaultChroniclesStreamOutputs
            [][0])
          initLogRecord(record_8942275011, LogLevel(3), "eth66",
                        "Peer matches our network")
          setProperty(record_8942275011, "tid", getLogThreadId())
          setProperty(record_8942275011, "file", "eth66.nim:128")
          mixin setProperty, formatItIMPL
          setProperty(record_8942275011, "peer", $peer.remote)
          logAllDynamicProperties(
            defaultChroniclesStream, record_8942275011)
          flushRecord(record_8942275011)
      except CatchableError as err`gensym2897:
        logLoggingFailure(cstring("Peer matches our network"), err`gensym2897)
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
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (eth66PeerConnected_8942273579, :env)
  futureContinue(resultFuture)
  return resultFuture

setEventHandlers(eth66Protocol, eth66PeerConnected, nil)
registerProtocol(eth66Protocol)