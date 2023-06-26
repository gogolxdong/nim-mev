
## Generated at line 75
type
  snap1 = object
template State(PROTO: type snap1): type =
  ref[SnapPeerState:ObjectType]

template NetworkState(PROTO: type snap1): type =
  ref[SnapWireBase:ObjectType]

type
  accountRangeObj = object
    accounts*: seq[SnapAccount]
    proof*: SnapProofNodes

template accountRange(PROTO: type snap1): type =
  accountRangeObj

template msgProtocol(MSG: type accountRangeObj): type =
  snap1

template RecType(MSG: type accountRangeObj): untyped =
  accountRangeObj

template msgId(MSG: type accountRangeObj): int =
  1

type
  getAccountRangeObj = object
    root*: Hash256
    origin*: seq[byte]
    limit*: seq[byte]
    replySizeMax*: uint64

template getAccountRange(PROTO: type snap1): type =
  getAccountRangeObj

template msgProtocol(MSG: type getAccountRangeObj): type =
  snap1

template RecType(MSG: type getAccountRangeObj): untyped =
  getAccountRangeObj

template msgId(MSG: type getAccountRangeObj): int =
  0

type
  storageRangesObj = object
    slotLists*: seq[seq[SnapStorage]]
    proof*: SnapProofNodes

template storageRanges(PROTO: type snap1): type =
  storageRangesObj

template msgProtocol(MSG: type storageRangesObj): type =
  snap1

template RecType(MSG: type storageRangesObj): untyped =
  storageRangesObj

template msgId(MSG: type storageRangesObj): int =
  3

type
  getStorageRangesObj = object
    root*: Hash256
    accounts*: seq[Hash256]
    origin*: seq[byte]
    limit*: seq[byte]
    replySizeMax*: uint64

template getStorageRanges(PROTO: type snap1): type =
  getStorageRangesObj

template msgProtocol(MSG: type getStorageRangesObj): type =
  snap1

template RecType(MSG: type getStorageRangesObj): untyped =
  getStorageRangesObj

template msgId(MSG: type getStorageRangesObj): int =
  2

type
  byteCodesObj = object
    codes*: seq[Blob]

template byteCodes(PROTO: type snap1): type =
  byteCodesObj

template msgProtocol(MSG: type byteCodesObj): type =
  snap1

template RecType(MSG: type byteCodesObj): untyped =
  byteCodesObj

template msgId(MSG: type byteCodesObj): int =
  5

type
  getByteCodesObj = object
    nodes*: seq[Hash256]
    replySizeMax*: uint64

template getByteCodes(PROTO: type snap1): type =
  getByteCodesObj

template msgProtocol(MSG: type getByteCodesObj): type =
  snap1

template RecType(MSG: type getByteCodesObj): untyped =
  getByteCodesObj

template msgId(MSG: type getByteCodesObj): int =
  4

type
  trieNodesObj = object
    nodes*: seq[Blob]

template trieNodes(PROTO: type snap1): type =
  trieNodesObj

template msgProtocol(MSG: type trieNodesObj): type =
  snap1

template RecType(MSG: type trieNodesObj): untyped =
  trieNodesObj

template msgId(MSG: type trieNodesObj): int =
  7

type
  getTrieNodesObj = object
    root*: Hash256
    pathGroups*: seq[SnapTriePaths]
    replySizeMax*: uint64

template getTrieNodes(PROTO: type snap1): type =
  getTrieNodesObj

template msgProtocol(MSG: type getTrieNodesObj): type =
  snap1

template RecType(MSG: type getTrieNodesObj): untyped =
  getTrieNodesObj

template msgId(MSG: type getTrieNodesObj): int =
  6

var snap1ProtocolObj = initProtocol("snap", 1, createPeerState,
                                    createNetworkState)
var snap1Protocol = addr snap1ProtocolObj
template protocolInfo(PROTO: type snap1): auto =
  snap1Protocol

proc accountRange(peerOrResponder: ResponderWithId[accountRangeObj];
                  accounts: openArray[SnapAccount]; proof: SnapProofNodes): Future[
    void] {.gcsafe.} =
  let peer = peerOrResponder.peer
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 1
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 1)
  appendInt(writer, perPeerMsgId)
  startList(writer, 3)
  appendInt(writer, peerOrResponder.reqId)
  appendImpl(writer, accounts)
  append(writer, proof)
  let msgBytes =
    const
      loc`gensym137 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym137 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template send(r`gensym23: ResponderWithId[accountRangeObj];
              args`gensym23: varargs[untyped]): auto =
  accountRange(r`gensym23, args`gensym23)

proc getAccountRange(peerOrResponder: Peer; root: Hash256;
                     origin: openArray[byte]; limit: openArray[byte];
                     replySizeMax: uint64;
                     timeout: Duration = milliseconds(10000'i64)): Future[
    Option[accountRangeObj]] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 0
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 0)
  appendInt(writer, perPeerMsgId)
  startList(writer, 5)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  appendInt(writer, reqId)
  append(writer, root)
  appendImpl(writer, origin)
  appendImpl(writer, limit)
  appendInt(writer, replySizeMax)
  let msgBytes =
    const
      loc`gensym151 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym151 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc storageRanges(peerOrResponder: ResponderWithId[storageRangesObj];
                   slotLists: openArray[seq[SnapStorage]]; proof: SnapProofNodes): Future[
    void] {.gcsafe.} =
  let peer = peerOrResponder.peer
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 3
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 3)
  appendInt(writer, perPeerMsgId)
  startList(writer, 3)
  appendInt(writer, peerOrResponder.reqId)
  appendImpl(writer, slotLists)
  append(writer, proof)
  let msgBytes =
    const
      loc`gensym174 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym174 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template send(r`gensym44: ResponderWithId[storageRangesObj];
              args`gensym44: varargs[untyped]): auto =
  storageRanges(r`gensym44, args`gensym44)

proc getStorageRanges(peerOrResponder: Peer; root: Hash256;
                      accounts: openArray[Hash256]; origin: openArray[byte];
                      limit: openArray[byte]; replySizeMax: uint64;
                      timeout: Duration = milliseconds(10000'i64)): Future[
    Option[storageRangesObj]] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 2
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 2)
  appendInt(writer, perPeerMsgId)
  startList(writer, 6)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  appendInt(writer, reqId)
  append(writer, root)
  appendImpl(writer, accounts)
  appendImpl(writer, origin)
  appendImpl(writer, limit)
  appendInt(writer, replySizeMax)
  let msgBytes =
    const
      loc`gensym189 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym189 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc byteCodes(peerOrResponder: ResponderWithId[byteCodesObj];
               codes: openArray[Blob]): Future[void] {.gcsafe.} =
  let peer = peerOrResponder.peer
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 5
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 5)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendInt(writer, peerOrResponder.reqId)
  appendImpl(writer, codes)
  let msgBytes =
    const
      loc`gensym200 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym200 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template send(r`gensym65: ResponderWithId[byteCodesObj];
              args`gensym65: varargs[untyped]): auto =
  byteCodes(r`gensym65, args`gensym65)

proc getByteCodes(peerOrResponder: Peer; nodes: openArray[Hash256];
                  replySizeMax: uint64;
                  timeout: Duration = milliseconds(10000'i64)): Future[
    Option[byteCodesObj]] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 4
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 4)
  appendInt(writer, perPeerMsgId)
  startList(writer, 3)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  appendInt(writer, reqId)
  appendImpl(writer, nodes)
  appendInt(writer, replySizeMax)
  let msgBytes =
    const
      loc`gensym213 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym213 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc trieNodes(peerOrResponder: ResponderWithId[trieNodesObj];
               nodes: openArray[Blob]): Future[void] {.gcsafe.} =
  let peer = peerOrResponder.peer
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 7
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 7)
  appendInt(writer, perPeerMsgId)
  startList(writer, 2)
  appendInt(writer, peerOrResponder.reqId)
  appendImpl(writer, nodes)
  let msgBytes =
    const
      loc`gensym224 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym224 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  return sendMsg(peer, msgBytes)

template send(r`gensym83: ResponderWithId[trieNodesObj];
              args`gensym83: varargs[untyped]): auto =
  trieNodes(r`gensym83, args`gensym83)

proc getTrieNodes(peerOrResponder: Peer; root: Hash256;
                  pathGroups: openArray[SnapTriePaths]; replySizeMax: uint64;
                  timeout: Duration = milliseconds(10000'i64)): Future[
    Option[trieNodesObj]] {.gcsafe.} =
  let peer = peerOrResponder
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 6
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 6)
  appendInt(writer, perPeerMsgId)
  startList(writer, 4)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  appendInt(writer, reqId)
  append(writer, root)
  appendImpl(writer, pathGroups)
  appendInt(writer, replySizeMax)
  let msgBytes =
    const
      loc`gensym237 = (
        filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
        line: 338, column: 11)
      ploc`gensym237 = "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12)"
    bind instantiationInfo
    mixin failedAssertImpl
    {.line: (filename: "/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim",
             line: 338, column: 11).}:
      if not (len(writer.pendingLists) == 0):
        failedAssertImpl("/root/nimbus-eth1/vendor/nim-eth/eth/rlp/writer.nim(338, 12) `writer.pendingLists.len == 0` Insufficient number of elements written to a started list")
    writer.output
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc getAccountRangeUserHandler(peer: Peer; reqId: int; root: Hash256;
                                origin: seq[byte]; limit: seq[byte];
                                replySizeMax: uint64): Future[void] {.gcsafe,
    stackTrace: false, gcsafe, raises: [].} =
  iterator getAccountRangeUserHandler_8925480323(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = snap1
      const
        perProtocolMsgId = 0
      template state(peer: Peer): ref[SnapPeerState:ObjectType] =
        cast[ref[SnapPeerState:ObjectType]](getState(peer, snap1Protocol))

      template networkState(peer: Peer): ref[SnapWireBase:ObjectType] =
        cast[ref[SnapWireBase:ObjectType]](getNetworkState(peer.network,
            snap1Protocol))

      var response = init(ResponderWithId[accountRangeObj], peer, reqId)
      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
          try:
            block chroniclesLogStmt:
              if not topicsMatch(LogLevel(1), [topicStateIMPL("snap1")]):
                break chroniclesLogStmt
              var record_8925480370:
                defaultChroniclesStreamLogRecord
              mixin activateOutput
              record_8925480370 = default(typeof(record_8925480370))
              if {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0].outFile ==
                  nil:
                openOutput( {.gcsafe.}:
                  addr defaultChroniclesStreamOutputs
                [][0])
              initLogRecord(record_8925480370, LogLevel(1), "snap1",
                            "<< [snap/1] Received GetAccountRange (0x00)")
              setProperty(record_8925480370, "tid", getLogThreadId())
              setProperty(record_8925480370, "file", "snap1.nim:90")
              mixin setProperty, formatItIMPL
              setProperty(record_8925480370, "peer", $peer.remote)
              mixin setProperty, formatItIMPL
              setProperty(record_8925480370, "root", root)
              mixin setProperty, formatItIMPL
              setProperty(record_8925480370, "nOrigin", len(origin))
              mixin setProperty, formatItIMPL
              setProperty(record_8925480370, "nLimit", len(limit))
              mixin setProperty, formatItIMPL
              setProperty(record_8925480370, "replySizeMax", replySizeMax)
              logAllDynamicProperties(
                defaultChroniclesStream, record_8925480370)
              flushRecord(record_8925480370)
          except CatchableError as err`gensym251:
            logLoggingFailure(cstring("<< [snap/1] Received GetAccountRange (0x00)"),
                              err`gensym251)
        except:
          discard
        {.pop.}
      let
        ctx = cast[ref[SnapWireBase:ObjectType]](getNetworkState(peer.network,
            snap1Protocol))
        (accounts, proof) = getAccountRange(ctx, root, origin, limit,
            replySizeMax)
        nAccounts = len(accounts)
        nProof = len(proof.nodes)
      if nAccounts == 0 and nProof == 0:
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
            try:
              block chroniclesLogStmt:
                if not topicsMatch(LogLevel(1), [topicStateIMPL("snap1")]):
                  break chroniclesLogStmt
                var record_8925480515:
                  defaultChroniclesStreamLogRecord
                mixin activateOutput
                record_8925480515 = default(typeof(record_8925480515))
                if {.gcsafe.}:
                  addr defaultChroniclesStreamOutputs
                [][0].outFile ==
                    nil:
                  openOutput( {.gcsafe.}:
                    addr defaultChroniclesStreamOutputs
                  [][0])
                initLogRecord(record_8925480515, LogLevel(1), "snap1",
                              ">> [snap/1] Replying EMPTY AccountRange (0x01)")
                setProperty(record_8925480515, "tid", getLogThreadId())
                setProperty(record_8925480515, "file", "snap1.nim:103")
                mixin setProperty, formatItIMPL
                setProperty(record_8925480515, "peer", $peer.remote)
                logAllDynamicProperties(
                  defaultChroniclesStream, record_8925480515)
                flushRecord(record_8925480515)
            except CatchableError as err`gensym278:
              logLoggingFailure(cstring(">> [snap/1] Replying EMPTY AccountRange (0x01)"),
                                err`gensym278)
          except:
            discard
          {.pop.}
      else:
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
            try:
              block chroniclesLogStmt:
                if not topicsMatch(LogLevel(1), [topicStateIMPL("snap1")]):
                  break chroniclesLogStmt
                var record_8925480599:
                  defaultChroniclesStreamLogRecord
                mixin activateOutput
                record_8925480599 = default(typeof(record_8925480599))
                if {.gcsafe.}:
                  addr defaultChroniclesStreamOutputs
                [][0].outFile ==
                    nil:
                  openOutput( {.gcsafe.}:
                    addr defaultChroniclesStreamOutputs
                  [][0])
                initLogRecord(record_8925480599, LogLevel(1), "snap1",
                              ">> [snap/1] Replying AccountRange (0x01)")
                setProperty(record_8925480599, "tid", getLogThreadId())
                setProperty(record_8925480599, "file", "snap1.nim:105")
                mixin setProperty, formatItIMPL
                setProperty(record_8925480599, "peer", $peer.remote)
                mixin setProperty, formatItIMPL
                setProperty(record_8925480599, "nAccounts", nAccounts)
                mixin setProperty, formatItIMPL
                setProperty(record_8925480599, "nProof", nProof)
                logAllDynamicProperties(
                  defaultChroniclesStream, record_8925480599)
                flushRecord(record_8925480599)
            except CatchableError as err`gensym296:
              logLoggingFailure(cstring(">> [snap/1] Replying AccountRange (0x01)"),
                                err`gensym296)
          except:
            discard
          {.pop.}
      chronosInternalRetFuture.internalChild = accountRange(response, accounts,
          proof)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "snap1.nim", line: 90, column: 6).filename,
        (filename: "snap1.nim", line: 90, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getAccountRangeUserHandler", (
        filename: "snap1.nim", line: 90, column: 6).filename,
                             (filename: "snap1.nim", line: 90, column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getAccountRangeUserHandler_8925480323, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getStorageRangesUserHandler(peer: Peer; reqId: int; root: Hash256;
                                 accounts: seq[Hash256]; origin: seq[byte];
                                 limit: seq[byte]; replySizeMax: uint64): Future[
    void] {.gcsafe, stackTrace: false, gcsafe, raises: [].} =
  iterator getStorageRangesUserHandler_8925480750(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = snap1
      const
        perProtocolMsgId = 2
      template state(peer: Peer): ref[SnapPeerState:ObjectType] =
        cast[ref[SnapPeerState:ObjectType]](getState(peer, snap1Protocol))

      template networkState(peer: Peer): ref[SnapWireBase:ObjectType] =
        cast[ref[SnapWireBase:ObjectType]](getNetworkState(peer.network,
            snap1Protocol))

      var response = init(ResponderWithId[storageRangesObj], peer, reqId)
      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
          try:
            block chroniclesLogStmt:
              if not topicsMatch(LogLevel(1), [topicStateIMPL("snap1")]):
                break chroniclesLogStmt
              var record_8925480798:
                defaultChroniclesStreamLogRecord
              mixin activateOutput
              record_8925480798 = default(typeof(record_8925480798))
              if {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0].outFile ==
                  nil:
                openOutput( {.gcsafe.}:
                  addr defaultChroniclesStreamOutputs
                [][0])
              initLogRecord(record_8925480798, LogLevel(1), "snap1",
                            "<< [snap/1] Received GetStorageRanges (0x02)")
              setProperty(record_8925480798, "tid", getLogThreadId())
              setProperty(record_8925480798, "file", "snap1.nim:127")
              mixin setProperty, formatItIMPL
              setProperty(record_8925480798, "peer", $peer.remote)
              mixin setProperty, formatItIMPL
              setProperty(record_8925480798, "root", root)
              mixin setProperty, formatItIMPL
              setProperty(record_8925480798, "nAccounts", len(accounts))
              mixin setProperty, formatItIMPL
              setProperty(record_8925480798, "nOrigin", len(origin))
              mixin setProperty, formatItIMPL
              setProperty(record_8925480798, "nLimit", len(limit))
              mixin setProperty, formatItIMPL
              setProperty(record_8925480798, "replySizeMax", replySizeMax)
              logAllDynamicProperties(
                defaultChroniclesStream, record_8925480798)
              flushRecord(record_8925480798)
          except CatchableError as err`gensym329:
            logLoggingFailure(cstring("<< [snap/1] Received GetStorageRanges (0x02)"),
                              err`gensym329)
        except:
          discard
        {.pop.}
      let
        ctx = cast[ref[SnapWireBase:ObjectType]](getNetworkState(peer.network,
            snap1Protocol))
        (slots, proof) = getStorageRanges(ctx, root, accounts, origin, limit,
            replySizeMax)
        nSlots = len(slots)
        nProof = len(proof.nodes)
      if nSlots == 0 and nProof == 0:
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
            try:
              block chroniclesLogStmt:
                if not topicsMatch(LogLevel(1), [topicStateIMPL("snap1")]):
                  break chroniclesLogStmt
                var record_8925480953:
                  defaultChroniclesStreamLogRecord
                mixin activateOutput
                record_8925480953 = default(typeof(record_8925480953))
                if {.gcsafe.}:
                  addr defaultChroniclesStreamOutputs
                [][0].outFile ==
                    nil:
                  openOutput( {.gcsafe.}:
                    addr defaultChroniclesStreamOutputs
                  [][0])
                initLogRecord(record_8925480953, LogLevel(1), "snap1",
                              ">> [snap/1] Replying EMPTY StorageRanges (0x03)")
                setProperty(record_8925480953, "tid", getLogThreadId())
                setProperty(record_8925480953, "file", "snap1.nim:141")
                mixin setProperty, formatItIMPL
                setProperty(record_8925480953, "peer", $peer.remote)
                logAllDynamicProperties(
                  defaultChroniclesStream, record_8925480953)
                flushRecord(record_8925480953)
            except CatchableError as err`gensym358:
              logLoggingFailure(cstring(">> [snap/1] Replying EMPTY StorageRanges (0x03)"),
                                err`gensym358)
          except:
            discard
          {.pop.}
      else:
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
            try:
              block chroniclesLogStmt:
                if not topicsMatch(LogLevel(1), [topicStateIMPL("snap1")]):
                  break chroniclesLogStmt
                var record_8925481037:
                  defaultChroniclesStreamLogRecord
                mixin activateOutput
                record_8925481037 = default(typeof(record_8925481037))
                if {.gcsafe.}:
                  addr defaultChroniclesStreamOutputs
                [][0].outFile ==
                    nil:
                  openOutput( {.gcsafe.}:
                    addr defaultChroniclesStreamOutputs
                  [][0])
                initLogRecord(record_8925481037, LogLevel(1), "snap1",
                              ">> [snap/1] Replying StorageRanges (0x03)")
                setProperty(record_8925481037, "tid", getLogThreadId())
                setProperty(record_8925481037, "file", "snap1.nim:143")
                mixin setProperty, formatItIMPL
                setProperty(record_8925481037, "peer", $peer.remote)
                mixin setProperty, formatItIMPL
                setProperty(record_8925481037, "nSlots", nSlots)
                mixin setProperty, formatItIMPL
                setProperty(record_8925481037, "nProof", nProof)
                logAllDynamicProperties(
                  defaultChroniclesStream, record_8925481037)
                flushRecord(record_8925481037)
            except CatchableError as err`gensym376:
              logLoggingFailure(cstring(">> [snap/1] Replying StorageRanges (0x03)"),
                                err`gensym376)
          except:
            discard
          {.pop.}
      chronosInternalRetFuture.internalChild = storageRanges(response, slots,
          proof)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "snap1.nim", line: 127, column: 6).filename,
        (filename: "snap1.nim", line: 127, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getStorageRangesUserHandler", (
        filename: "snap1.nim", line: 127, column: 6).filename, (
        filename: "snap1.nim", line: 127, column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getStorageRangesUserHandler_8925480750, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getByteCodesUserHandler(peer: Peer; reqId: int; nodes: seq[Hash256];
                             replySizeMax: uint64): Future[void] {.gcsafe,
    stackTrace: false, gcsafe, raises: [].} =
  iterator getByteCodesUserHandler_8925481179(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = snap1
      const
        perProtocolMsgId = 4
      template state(peer: Peer): ref[SnapPeerState:ObjectType] =
        cast[ref[SnapPeerState:ObjectType]](getState(peer, snap1Protocol))

      template networkState(peer: Peer): ref[SnapWireBase:ObjectType] =
        cast[ref[SnapWireBase:ObjectType]](getNetworkState(peer.network,
            snap1Protocol))

      var response = init(ResponderWithId[byteCodesObj], peer, reqId)
      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
          try:
            block chroniclesLogStmt:
              if not topicsMatch(LogLevel(1), [topicStateIMPL("snap1")]):
                break chroniclesLogStmt
              var record_8925481224:
                defaultChroniclesStreamLogRecord
              mixin activateOutput
              record_8925481224 = default(typeof(record_8925481224))
              if {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0].outFile ==
                  nil:
                openOutput( {.gcsafe.}:
                  addr defaultChroniclesStreamOutputs
                [][0])
              initLogRecord(record_8925481224, LogLevel(1), "snap1",
                            "<< [snap/1] Received GetByteCodes (0x04)")
              setProperty(record_8925481224, "tid", getLogThreadId())
              setProperty(record_8925481224, "file", "snap1.nim:163")
              mixin setProperty, formatItIMPL
              setProperty(record_8925481224, "peer", $peer.remote)
              mixin setProperty, formatItIMPL
              setProperty(record_8925481224, "nNodes", len(nodes))
              mixin setProperty, formatItIMPL
              setProperty(record_8925481224, "replySizeMax", replySizeMax)
              logAllDynamicProperties(
                defaultChroniclesStream, record_8925481224)
              flushRecord(record_8925481224)
          except CatchableError as err`gensym409:
            logLoggingFailure(cstring("<< [snap/1] Received GetByteCodes (0x04)"),
                              err`gensym409)
        except:
          discard
        {.pop.}
      let
        ctx = cast[ref[SnapWireBase:ObjectType]](getNetworkState(peer.network,
            snap1Protocol))
        codes = getByteCodes(ctx, nodes, replySizeMax)
        nCodes = len(codes)
      if nCodes == 0:
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
            try:
              block chroniclesLogStmt:
                if not topicsMatch(LogLevel(1), [topicStateIMPL("snap1")]):
                  break chroniclesLogStmt
                var record_8925481337:
                  defaultChroniclesStreamLogRecord
                mixin activateOutput
                record_8925481337 = default(typeof(record_8925481337))
                if {.gcsafe.}:
                  addr defaultChroniclesStreamOutputs
                [][0].outFile ==
                    nil:
                  openOutput( {.gcsafe.}:
                    addr defaultChroniclesStreamOutputs
                  [][0])
                initLogRecord(record_8925481337, LogLevel(1), "snap1",
                              ">> [snap/1] Replying EMPTY ByteCodes (0x05)")
                setProperty(record_8925481337, "tid", getLogThreadId())
                setProperty(record_8925481337, "file", "snap1.nim:174")
                mixin setProperty, formatItIMPL
                setProperty(record_8925481337, "peer", $peer.remote)
                logAllDynamicProperties(
                  defaultChroniclesStream, record_8925481337)
                flushRecord(record_8925481337)
            except CatchableError as err`gensym432:
              logLoggingFailure(cstring(">> [snap/1] Replying EMPTY ByteCodes (0x05)"),
                                err`gensym432)
          except:
            discard
          {.pop.}
      else:
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
            try:
              block chroniclesLogStmt:
                if not topicsMatch(LogLevel(1), [topicStateIMPL("snap1")]):
                  break chroniclesLogStmt
                var record_8925481421:
                  defaultChroniclesStreamLogRecord
                mixin activateOutput
                record_8925481421 = default(typeof(record_8925481421))
                if {.gcsafe.}:
                  addr defaultChroniclesStreamOutputs
                [][0].outFile ==
                    nil:
                  openOutput( {.gcsafe.}:
                    addr defaultChroniclesStreamOutputs
                  [][0])
                initLogRecord(record_8925481421, LogLevel(1), "snap1",
                              ">> [snap/1] Replying ByteCodes (0x05)")
                setProperty(record_8925481421, "tid", getLogThreadId())
                setProperty(record_8925481421, "file", "snap1.nim:176")
                mixin setProperty, formatItIMPL
                setProperty(record_8925481421, "peer", $peer.remote)
                mixin setProperty, formatItIMPL
                setProperty(record_8925481421, "nCodes", nCodes)
                logAllDynamicProperties(
                  defaultChroniclesStream, record_8925481421)
                flushRecord(record_8925481421)
            except CatchableError as err`gensym450:
              logLoggingFailure(cstring(">> [snap/1] Replying ByteCodes (0x05)"),
                                err`gensym450)
          except:
            discard
          {.pop.}
      chronosInternalRetFuture.internalChild = byteCodes(response, codes)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "snap1.nim", line: 163, column: 6).filename,
        (filename: "snap1.nim", line: 163, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getByteCodesUserHandler", (filename: "snap1.nim",
        line: 163, column: 6).filename, (filename: "snap1.nim", line: 163,
        column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getByteCodesUserHandler_8925481179, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getTrieNodesUserHandler(peer: Peer; reqId: int; root: Hash256;
                             pathGroups: seq[SnapTriePaths];
                             replySizeMax: uint64): Future[void] {.gcsafe,
    stackTrace: false, gcsafe, raises: [].} =
  iterator getTrieNodesUserHandler_8925481526(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      type
        CurrentProtocol = snap1
      const
        perProtocolMsgId = 6
      template state(peer: Peer): ref[SnapPeerState:ObjectType] =
        cast[ref[SnapPeerState:ObjectType]](getState(peer, snap1Protocol))

      template networkState(peer: Peer): ref[SnapWireBase:ObjectType] =
        cast[ref[SnapWireBase:ObjectType]](getNetworkState(peer.network,
            snap1Protocol))

      var response = init(ResponderWithId[trieNodesObj], peer, reqId)
      {.noSideEffect.}:
        {.push, warning[BareExcept]: false.}
        try:
          bind logIMPL, bindSym, brForceOpen
          try:
            block chroniclesLogStmt:
              if not topicsMatch(LogLevel(1), [topicStateIMPL("snap1")]):
                break chroniclesLogStmt
              var record_8925481572:
                defaultChroniclesStreamLogRecord
              mixin activateOutput
              record_8925481572 = default(typeof(record_8925481572))
              if {.gcsafe.}:
                addr defaultChroniclesStreamOutputs
              [][0].outFile ==
                  nil:
                openOutput( {.gcsafe.}:
                  addr defaultChroniclesStreamOutputs
                [][0])
              initLogRecord(record_8925481572, LogLevel(1), "snap1",
                            "<< [snap/1] Received GetTrieNodes (0x06)")
              setProperty(record_8925481572, "tid", getLogThreadId())
              setProperty(record_8925481572, "file", "snap1.nim:194")
              mixin setProperty, formatItIMPL
              setProperty(record_8925481572, "peer", $peer.remote)
              mixin setProperty, formatItIMPL
              setProperty(record_8925481572, "root", root)
              mixin setProperty, formatItIMPL
              setProperty(record_8925481572, "nPathGroups", len(pathGroups))
              mixin setProperty, formatItIMPL
              setProperty(record_8925481572, "replySizeMax", replySizeMax)
              logAllDynamicProperties(
                defaultChroniclesStream, record_8925481572)
              flushRecord(record_8925481572)
          except CatchableError as err`gensym481:
            logLoggingFailure(cstring("<< [snap/1] Received GetTrieNodes (0x06)"),
                              err`gensym481)
        except:
          discard
        {.pop.}
      let
        ctx = cast[ref[SnapWireBase:ObjectType]](getNetworkState(peer.network,
            snap1Protocol))
        nodes = getTrieNodes(ctx, root, pathGroups, replySizeMax)
        nNodes = len(nodes)
      if nNodes == 0:
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
            try:
              block chroniclesLogStmt:
                if not topicsMatch(LogLevel(1), [topicStateIMPL("snap1")]):
                  break chroniclesLogStmt
                var record_8925481696:
                  defaultChroniclesStreamLogRecord
                mixin activateOutput
                record_8925481696 = default(typeof(record_8925481696))
                if {.gcsafe.}:
                  addr defaultChroniclesStreamOutputs
                [][0].outFile ==
                    nil:
                  openOutput( {.gcsafe.}:
                    addr defaultChroniclesStreamOutputs
                  [][0])
                initLogRecord(record_8925481696, LogLevel(1), "snap1",
                              ">> [snap/1] Replying EMPTY TrieNodes (0x07)")
                setProperty(record_8925481696, "tid", getLogThreadId())
                setProperty(record_8925481696, "file", "snap1.nim:205")
                mixin setProperty, formatItIMPL
                setProperty(record_8925481696, "peer", $peer.remote)
                logAllDynamicProperties(
                  defaultChroniclesStream, record_8925481696)
                flushRecord(record_8925481696)
            except CatchableError as err`gensym506:
              logLoggingFailure(cstring(">> [snap/1] Replying EMPTY TrieNodes (0x07)"),
                                err`gensym506)
          except:
            discard
          {.pop.}
      else:
        {.noSideEffect.}:
          {.push, warning[BareExcept]: false.}
          try:
            bind logIMPL, bindSym, brForceOpen
            try:
              block chroniclesLogStmt:
                if not topicsMatch(LogLevel(1), [topicStateIMPL("snap1")]):
                  break chroniclesLogStmt
                var record_8925481780:
                  defaultChroniclesStreamLogRecord
                mixin activateOutput
                record_8925481780 = default(typeof(record_8925481780))
                if {.gcsafe.}:
                  addr defaultChroniclesStreamOutputs
                [][0].outFile ==
                    nil:
                  openOutput( {.gcsafe.}:
                    addr defaultChroniclesStreamOutputs
                  [][0])
                initLogRecord(record_8925481780, LogLevel(1), "snap1",
                              ">> [snap/1] Replying TrieNodes (0x07)")
                setProperty(record_8925481780, "tid", getLogThreadId())
                setProperty(record_8925481780, "file", "snap1.nim:207")
                mixin setProperty, formatItIMPL
                setProperty(record_8925481780, "peer", $peer.remote)
                mixin setProperty, formatItIMPL
                setProperty(record_8925481780, "nNodes", nNodes)
                logAllDynamicProperties(
                  defaultChroniclesStream, record_8925481780)
                flushRecord(record_8925481780)
            except CatchableError as err`gensym524:
              logLoggingFailure(cstring(">> [snap/1] Replying TrieNodes (0x07)"),
                                err`gensym524)
          except:
            discard
          {.pop.}
      chronosInternalRetFuture.internalChild = trieNodes(response, nodes)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "snap1.nim", line: 194, column: 6).filename,
        (filename: "snap1.nim", line: 194, column: 6).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getTrieNodesUserHandler", (filename: "snap1.nim",
        line: 194, column: 6).filename, (filename: "snap1.nim", line: 194,
        column: 6).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getTrieNodesUserHandler_8925481526, :env)
  futureContinue(resultFuture)
  return resultFuture

proc accountRangeThunk(peer: Peer; _`gensym22: int; data`gensym22: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator accountRangeThunk_8925481903(chronosInternalRetFuture: FutureBase;
                                        :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym22
      var msg: accountRangeObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.accounts = checkedRlpRead(peer, rlp, openArray[SnapAccount])
      msg.proof = checkedRlpRead(peer, rlp, SnapProofNodes)
      resolveResponseFuture(peer, perPeerMsgIdImpl(peer, snap1Protocol, 1),
                            addr(msg), reqId)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("accountRangeThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (accountRangeThunk_8925481903, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getAccountRangeThunk(peer: Peer; _`gensym35: int; data`gensym35: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getAccountRangeThunk_8925482303(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym35
      var msg: getAccountRangeObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.root = checkedRlpRead(peer, rlp, Hash256)
      msg.origin = checkedRlpRead(peer, rlp, openArray[byte])
      msg.limit = checkedRlpRead(peer, rlp, openArray[byte])
      msg.replySizeMax = checkedRlpRead(peer, rlp, uint64)
      chronosInternalRetFuture.internalChild = getAccountRangeUserHandler(peer,
          reqId, msg.root, msg.origin, msg.limit, msg.replySizeMax)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getAccountRangeThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getAccountRangeThunk_8925482303, :env)
  futureContinue(resultFuture)
  return resultFuture

proc storageRangesThunk(peer: Peer; _`gensym43: int; data`gensym43: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator storageRangesThunk_8925482399(chronosInternalRetFuture: FutureBase;
      :envP): FutureBase {.closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym43
      var msg: storageRangesObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.slotLists = checkedRlpRead(peer, rlp, openArray[seq[SnapStorage]])
      msg.proof = checkedRlpRead(peer, rlp, SnapProofNodes)
      resolveResponseFuture(peer, perPeerMsgIdImpl(peer, snap1Protocol, 3),
                            addr(msg), reqId)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("storageRangesThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (storageRangesThunk_8925482399, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getStorageRangesThunk(peer: Peer; _`gensym57: int; data`gensym57: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getStorageRangesThunk_8925482617(
      chronosInternalRetFuture: FutureBase; :envP): FutureBase {.closure,
      gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym57
      var msg: getStorageRangesObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.root = checkedRlpRead(peer, rlp, Hash256)
      msg.accounts = checkedRlpRead(peer, rlp, openArray[Hash256])
      msg.origin = checkedRlpRead(peer, rlp, openArray[byte])
      msg.limit = checkedRlpRead(peer, rlp, openArray[byte])
      msg.replySizeMax = checkedRlpRead(peer, rlp, uint64)
      chronosInternalRetFuture.internalChild = getStorageRangesUserHandler(peer,
          reqId, msg.root, msg.accounts, msg.origin, msg.limit, msg.replySizeMax)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getStorageRangesThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getStorageRangesThunk_8925482617, :env)
  futureContinue(resultFuture)
  return resultFuture

proc byteCodesThunk(peer: Peer; _`gensym64: int; data`gensym64: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator byteCodesThunk_8925482698(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
      closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym64
      var msg: byteCodesObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.codes = checkedRlpRead(peer, rlp, openArray[Blob])
      resolveResponseFuture(peer, perPeerMsgIdImpl(peer, snap1Protocol, 5),
                            addr(msg), reqId)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("byteCodesThunk", (filename: "rlpx.nim", line: 966,
        column: 8).filename, (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (byteCodesThunk_8925482698, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getByteCodesThunk(peer: Peer; _`gensym75: int; data`gensym75: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getByteCodesThunk_8925482772(chronosInternalRetFuture: FutureBase;
                                        :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym75
      var msg: getByteCodesObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.nodes = checkedRlpRead(peer, rlp, openArray[Hash256])
      msg.replySizeMax = checkedRlpRead(peer, rlp, uint64)
      chronosInternalRetFuture.internalChild = getByteCodesUserHandler(peer,
          reqId, msg.nodes, msg.replySizeMax)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getByteCodesThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getByteCodesThunk_8925482772, :env)
  futureContinue(resultFuture)
  return resultFuture

proc trieNodesThunk(peer: Peer; _`gensym82: int; data`gensym82: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator trieNodesThunk_8925482838(chronosInternalRetFuture: FutureBase; :envP): FutureBase {.
      closure, gcsafe, raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym82
      var msg: trieNodesObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.nodes = checkedRlpRead(peer, rlp, openArray[Blob])
      resolveResponseFuture(peer, perPeerMsgIdImpl(peer, snap1Protocol, 7),
                            addr(msg), reqId)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("trieNodesThunk", (filename: "rlpx.nim", line: 966,
        column: 8).filename, (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (trieNodesThunk_8925482838, :env)
  futureContinue(resultFuture)
  return resultFuture

proc getTrieNodesThunk(peer: Peer; _`gensym94: int; data`gensym94: Rlp): Future[
    void] {.gcsafe, raises: [RlpError], stackTrace: false, gcsafe, raises: [].} =
  iterator getTrieNodesThunk_8925482912(chronosInternalRetFuture: FutureBase;
                                        :envP): FutureBase {.closure, gcsafe,
      raises: [Exception], gcsafe.} =
    template result(): auto {.used.} =
      {.fatal: "You should not reference the `result` variable inside" &
          " a void async proc".}

    block:
      var rlp = data`gensym94
      var msg: getTrieNodesObj
      tryEnterList(rlp)
      let reqId = readImpl(rlp, int)
      msg.root = checkedRlpRead(peer, rlp, Hash256)
      msg.pathGroups = checkedRlpRead(peer, rlp, openArray[SnapTriePaths])
      msg.replySizeMax = checkedRlpRead(peer, rlp, uint64)
      chronosInternalRetFuture.internalChild = getTrieNodesUserHandler(peer,
          reqId, msg.root, msg.pathGroups, msg.replySizeMax)
      yield chronosInternalRetFuture.internalChild
      if chronosInternalRetFuture.internalMustCancel:
        raise (ref CancelledError)(msg: "Future operation cancelled!")
      internalCheckComplete(chronosInternalRetFuture.internalChild)
    complete(cast[Future[void]](chronosInternalRetFuture), srcLocImpl("",
        (filename: "rlpx.nim", line: 966, column: 8).filename,
        (filename: "rlpx.nim", line: 966, column: 8).line))

  let resultFuture =
    newFutureImpl(srcLocImpl("getTrieNodesThunk", (filename: "rlpx.nim",
        line: 966, column: 8).filename,
                             (filename: "rlpx.nim", line: 966, column: 8).line))
  resultFuture.internalClosure =
    var :env
    internalNew(:env)
    :env.`:up` = :env
    (getTrieNodesThunk_8925482912, :env)
  futureContinue(resultFuture)
  return resultFuture

registerMsg(snap1Protocol, 1, "accountRange", accountRangeThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(snap1Protocol, 0, "getAccountRange", getAccountRangeThunk,
            messagePrinter, requestResolver, nextMsgResolver)
registerMsg(snap1Protocol, 3, "storageRanges", storageRangesThunk,
            messagePrinter, requestResolver, nextMsgResolver)
registerMsg(snap1Protocol, 2, "getStorageRanges", getStorageRangesThunk,
            messagePrinter, requestResolver, nextMsgResolver)
registerMsg(snap1Protocol, 5, "byteCodes", byteCodesThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(snap1Protocol, 4, "getByteCodes", getByteCodesThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(snap1Protocol, 7, "trieNodes", trieNodesThunk, messagePrinter,
            requestResolver, nextMsgResolver)
registerMsg(snap1Protocol, 6, "getTrieNodes", getTrieNodesThunk, messagePrinter,
            requestResolver, nextMsgResolver)
setEventHandlers(snap1Protocol, nil, nil)
registerProtocol(snap1Protocol)