
## Generated at line 75
type
  snap1* = object
template State*(PROTO: type snap1): type =
  ref[SnapPeerState:ObjectType]

template NetworkState*(PROTO: type snap1): type =
  ref[SnapWireBase:ObjectType]

type
  accountRangeObj* = object
    accounts*: seq[SnapAccount]
    proof*: SnapProofNodes

template accountRange*(PROTO: type snap1): type =
  accountRangeObj

template msgProtocol*(MSG: type accountRangeObj): type =
  snap1

template RecType*(MSG: type accountRangeObj): untyped =
  accountRangeObj

template msgId*(MSG: type accountRangeObj): int =
  1

type
  getAccountRangeObj* = object
    root*: Hash256
    origin*: seq[byte]
    limit*: seq[byte]
    replySizeMax*: uint64

template getAccountRange*(PROTO: type snap1): type =
  getAccountRangeObj

template msgProtocol*(MSG: type getAccountRangeObj): type =
  snap1

template RecType*(MSG: type getAccountRangeObj): untyped =
  getAccountRangeObj

template msgId*(MSG: type getAccountRangeObj): int =
  0

type
  storageRangesObj* = object
    slotLists*: seq[seq[SnapStorage]]
    proof*: SnapProofNodes

template storageRanges*(PROTO: type snap1): type =
  storageRangesObj

template msgProtocol*(MSG: type storageRangesObj): type =
  snap1

template RecType*(MSG: type storageRangesObj): untyped =
  storageRangesObj

template msgId*(MSG: type storageRangesObj): int =
  3

type
  getStorageRangesObj* = object
    root*: Hash256
    accounts*: seq[Hash256]
    origin*: seq[byte]
    limit*: seq[byte]
    replySizeMax*: uint64

template getStorageRanges*(PROTO: type snap1): type =
  getStorageRangesObj

template msgProtocol*(MSG: type getStorageRangesObj): type =
  snap1

template RecType*(MSG: type getStorageRangesObj): untyped =
  getStorageRangesObj

template msgId*(MSG: type getStorageRangesObj): int =
  2

type
  byteCodesObj* = object
    codes*: seq[Blob]

template byteCodes*(PROTO: type snap1): type =
  byteCodesObj

template msgProtocol*(MSG: type byteCodesObj): type =
  snap1

template RecType*(MSG: type byteCodesObj): untyped =
  byteCodesObj

template msgId*(MSG: type byteCodesObj): int =
  5

type
  getByteCodesObj* = object
    nodes*: seq[Hash256]
    replySizeMax*: uint64

template getByteCodes*(PROTO: type snap1): type =
  getByteCodesObj

template msgProtocol*(MSG: type getByteCodesObj): type =
  snap1

template RecType*(MSG: type getByteCodesObj): untyped =
  getByteCodesObj

template msgId*(MSG: type getByteCodesObj): int =
  4

type
  trieNodesObj* = object
    nodes*: seq[Blob]

template trieNodes*(PROTO: type snap1): type =
  trieNodesObj

template msgProtocol*(MSG: type trieNodesObj): type =
  snap1

template RecType*(MSG: type trieNodesObj): untyped =
  trieNodesObj

template msgId*(MSG: type trieNodesObj): int =
  7

type
  getTrieNodesObj* = object
    root*: Hash256
    pathGroups*: seq[SnapTriePaths]
    replySizeMax*: uint64

template getTrieNodes*(PROTO: type snap1): type =
  getTrieNodesObj

template msgProtocol*(MSG: type getTrieNodesObj): type =
  snap1

template RecType*(MSG: type getTrieNodesObj): untyped =
  getTrieNodesObj

template msgId*(MSG: type getTrieNodesObj): int =
  6

var snap1ProtocolObj = initProtocol("snap", 1, createPeerState[Peer,
    ref[SnapPeerState:ObjectType]], createNetworkState[EthereumNode,
    ref[SnapWireBase:ObjectType]])
var snap1Protocol = addr snap1ProtocolObj
template protocolInfo*(PROTO: type snap1): auto =
  snap1Protocol

proc accountRange*(peerOrResponder: ResponderWithId[accountRangeObj];
                   accounts: openArray[SnapAccount]; proof: SnapProofNodes): Future[
    void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 1
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 1)
  append(writer, perPeerMsgId)
  startList(writer, 3)
  append(writer, peerOrResponder.reqId)
  append(writer, accounts)
  append(writer, proof)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym23: ResponderWithId[accountRangeObj];
               args`gensym23: varargs[untyped]): auto =
  accountRange(r`gensym23, args`gensym23)

proc getAccountRange*(peerOrResponder: Peer; root: Hash256;
                      origin: openArray[byte]; limit: openArray[byte];
                      replySizeMax: uint64;
                      timeout: Duration = milliseconds(10000'i64)): Future[
    Option[accountRangeObj]] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 0
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 0)
  append(writer, perPeerMsgId)
  startList(writer, 5)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, root)
  append(writer, origin)
  append(writer, limit)
  append(writer, replySizeMax)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc storageRanges*(peerOrResponder: ResponderWithId[storageRangesObj];
                    slotLists: openArray[seq[SnapStorage]];
                    proof: SnapProofNodes): Future[void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 3
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 3)
  append(writer, perPeerMsgId)
  startList(writer, 3)
  append(writer, peerOrResponder.reqId)
  append(writer, slotLists)
  append(writer, proof)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym44: ResponderWithId[storageRangesObj];
               args`gensym44: varargs[untyped]): auto =
  storageRanges(r`gensym44, args`gensym44)

proc getStorageRanges*(peerOrResponder: Peer; root: Hash256;
                       accounts: openArray[Hash256]; origin: openArray[byte];
                       limit: openArray[byte]; replySizeMax: uint64;
                       timeout: Duration = milliseconds(10000'i64)): Future[
    Option[storageRangesObj]] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 2
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 2)
  append(writer, perPeerMsgId)
  startList(writer, 6)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, root)
  append(writer, accounts)
  append(writer, origin)
  append(writer, limit)
  append(writer, replySizeMax)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc byteCodes*(peerOrResponder: ResponderWithId[byteCodesObj];
                codes: openArray[Blob]): Future[void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 5
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 5)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  append(writer, peerOrResponder.reqId)
  append(writer, codes)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym65: ResponderWithId[byteCodesObj];
               args`gensym65: varargs[untyped]): auto =
  byteCodes(r`gensym65, args`gensym65)

proc getByteCodes*(peerOrResponder: Peer; nodes: openArray[Hash256];
                   replySizeMax: uint64;
                   timeout: Duration = milliseconds(10000'i64)): Future[
    Option[byteCodesObj]] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 4
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 4)
  append(writer, perPeerMsgId)
  startList(writer, 3)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, nodes)
  append(writer, replySizeMax)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc trieNodes*(peerOrResponder: ResponderWithId[trieNodesObj];
                nodes: openArray[Blob]): Future[void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 7
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 7)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  append(writer, peerOrResponder.reqId)
  append(writer, nodes)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym83: ResponderWithId[trieNodesObj];
               args`gensym83: varargs[untyped]): auto =
  trieNodes(r`gensym83, args`gensym83)

proc getTrieNodes*(peerOrResponder: Peer; root: Hash256;
                   pathGroups: openArray[SnapTriePaths]; replySizeMax: uint64;
                   timeout: Duration = milliseconds(10000'i64)): Future[
    Option[trieNodesObj]] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 6
  let perPeerMsgId = perPeerMsgIdImpl(peer, snap1Protocol, 6)
  append(writer, perPeerMsgId)
  startList(writer, 4)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, root)
  append(writer, pathGroups)
  append(writer, replySizeMax)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc getAccountRangeUserHandler(peer: Peer; reqId: int; root: Hash256;
                                origin: seq[byte]; limit: seq[byte];
                                replySizeMax: uint64) {.gcsafe, async.} =
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
  trace trSnapRecvReceived & "GetAccountRange (0x00)", peer, root,
        nOrigin = origin.len, nLimit = limit.len, replySizeMax
  let
    ctx = peer.networkState()
    (accounts, proof) = ctx.getAccountRange(root, origin, limit, replySizeMax)
    nAccounts = accounts.len
    nProof = proof.nodes.len
  if nAccounts == 0 and nProof == 0:
    trace trSnapSendReplying & "EMPTY AccountRange (0x01)", peer
  else:
    trace trSnapSendReplying & "AccountRange (0x01)", peer, nAccounts, nProof
  await response.send(accounts, proof)

proc getStorageRangesUserHandler(peer: Peer; reqId: int; root: Hash256;
                                 accounts: seq[Hash256]; origin: seq[byte];
                                 limit: seq[byte]; replySizeMax: uint64) {.
    gcsafe, async.} =
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
  trace trSnapRecvReceived & "GetStorageRanges (0x02)", peer, root,
        nAccounts = accounts.len, nOrigin = origin.len, nLimit = limit.len,
        replySizeMax
  let
    ctx = peer.networkState()
    (slots, proof) = ctx.getStorageRanges(root, accounts, origin, limit,
        replySizeMax)
    nSlots = slots.len
    nProof = proof.nodes.len
  if nSlots == 0 and nProof == 0:
    trace trSnapSendReplying & "EMPTY StorageRanges (0x03)", peer
  else:
    trace trSnapSendReplying & "StorageRanges (0x03)", peer, nSlots, nProof
  await response.send(slots, proof)

proc getByteCodesUserHandler(peer: Peer; reqId: int; nodes: seq[Hash256];
                             replySizeMax: uint64) {.gcsafe, async.} =
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
  trace trSnapRecvReceived & "GetByteCodes (0x04)", peer, nNodes = nodes.len,
        replySizeMax
  let
    ctx = peer.networkState()
    codes = ctx.getByteCodes(nodes, replySizeMax)
    nCodes = codes.len
  if nCodes == 0:
    trace trSnapSendReplying & "EMPTY ByteCodes (0x05)", peer
  else:
    trace trSnapSendReplying & "ByteCodes (0x05)", peer, nCodes
  await response.send(codes)

proc getTrieNodesUserHandler(peer: Peer; reqId: int; root: Hash256;
                             pathGroups: seq[SnapTriePaths];
                             replySizeMax: uint64) {.gcsafe, async.} =
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
  trace trSnapRecvReceived & "GetTrieNodes (0x06)", peer, root,
        nPathGroups = pathGroups.len, replySizeMax
  let
    ctx = peer.networkState()
    nodes = ctx.getTrieNodes(root, pathGroups, replySizeMax)
    nNodes = nodes.len
  if nNodes == 0:
    trace trSnapSendReplying & "EMPTY TrieNodes (0x07)", peer
  else:
    trace trSnapSendReplying & "TrieNodes (0x07)", peer, nNodes
  await response.send(nodes)

proc accountRangeThunk(peer: Peer; _: int; data`gensym22: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym22
  var msg {.noinit.}: accountRangeObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.accounts = checkedRlpRead(peer, rlp, openArray[SnapAccount])
  msg.proof = checkedRlpRead(peer, rlp, SnapProofNodes)
  resolveResponseFuture(peer, perPeerMsgId(peer, accountRangeObj), addr(msg),
                        reqId)

proc getAccountRangeThunk(peer: Peer; _: int; data`gensym35: Rlp) {.async,
    gcsafe, raises: [RlpError].} =
  var rlp = data`gensym35
  var msg {.noinit.}: getAccountRangeObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.root = checkedRlpRead(peer, rlp, Hash256)
  msg.origin = checkedRlpRead(peer, rlp, openArray[byte])
  msg.limit = checkedRlpRead(peer, rlp, openArray[byte])
  msg.replySizeMax = checkedRlpRead(peer, rlp, uint64)
  await(getAccountRangeUserHandler(peer, reqId, msg.root, msg.origin, msg.limit,
                                   msg.replySizeMax))
  
proc storageRangesThunk(peer: Peer; _: int; data`gensym43: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym43
  var msg {.noinit.}: storageRangesObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.slotLists = checkedRlpRead(peer, rlp, openArray[seq[SnapStorage]])
  msg.proof = checkedRlpRead(peer, rlp, SnapProofNodes)
  resolveResponseFuture(peer, perPeerMsgId(peer, storageRangesObj), addr(msg),
                        reqId)

proc getStorageRangesThunk(peer: Peer; _: int; data`gensym57: Rlp) {.async,
    gcsafe, raises: [RlpError].} =
  var rlp = data`gensym57
  var msg {.noinit.}: getStorageRangesObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.root = checkedRlpRead(peer, rlp, Hash256)
  msg.accounts = checkedRlpRead(peer, rlp, openArray[Hash256])
  msg.origin = checkedRlpRead(peer, rlp, openArray[byte])
  msg.limit = checkedRlpRead(peer, rlp, openArray[byte])
  msg.replySizeMax = checkedRlpRead(peer, rlp, uint64)
  await(getStorageRangesUserHandler(peer, reqId, msg.root, msg.accounts,
                                    msg.origin, msg.limit, msg.replySizeMax))
  
proc byteCodesThunk(peer: Peer; _: int; data`gensym64: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym64
  var msg {.noinit.}: byteCodesObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.codes = checkedRlpRead(peer, rlp, openArray[Blob])
  resolveResponseFuture(peer, perPeerMsgId(peer, byteCodesObj), addr(msg), reqId)

proc getByteCodesThunk(peer: Peer; _: int; data`gensym75: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym75
  var msg {.noinit.}: getByteCodesObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.nodes = checkedRlpRead(peer, rlp, openArray[Hash256])
  msg.replySizeMax = checkedRlpRead(peer, rlp, uint64)
  await(getByteCodesUserHandler(peer, reqId, msg.nodes, msg.replySizeMax))
  
proc trieNodesThunk(peer: Peer; _: int; data`gensym82: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym82
  var msg {.noinit.}: trieNodesObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.nodes = checkedRlpRead(peer, rlp, openArray[Blob])
  resolveResponseFuture(peer, perPeerMsgId(peer, trieNodesObj), addr(msg), reqId)

proc getTrieNodesThunk(peer: Peer; _: int; data`gensym94: Rlp) {.async, gcsafe,
    raises: [RlpError].} =
  var rlp = data`gensym94
  var msg {.noinit.}: getTrieNodesObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.root = checkedRlpRead(peer, rlp, Hash256)
  msg.pathGroups = checkedRlpRead(peer, rlp, openArray[SnapTriePaths])
  msg.replySizeMax = checkedRlpRead(peer, rlp, uint64)
  await(getTrieNodesUserHandler(peer, reqId, msg.root, msg.pathGroups,
                                msg.replySizeMax))
  
registerMsg(snap1Protocol, 1, "accountRange", accountRangeThunk,
            messagePrinter[accountRangeObj], requestResolver[accountRangeObj],
            nextMsgResolver[accountRangeObj])
registerMsg(snap1Protocol, 0, "getAccountRange", getAccountRangeThunk,
            messagePrinter[getAccountRangeObj],
            requestResolver[getAccountRangeObj],
            nextMsgResolver[getAccountRangeObj])
registerMsg(snap1Protocol, 3, "storageRanges", storageRangesThunk,
            messagePrinter[storageRangesObj], requestResolver[storageRangesObj],
            nextMsgResolver[storageRangesObj])
registerMsg(snap1Protocol, 2, "getStorageRanges", getStorageRangesThunk,
            messagePrinter[getStorageRangesObj],
            requestResolver[getStorageRangesObj],
            nextMsgResolver[getStorageRangesObj])
registerMsg(snap1Protocol, 5, "byteCodes", byteCodesThunk,
            messagePrinter[byteCodesObj], requestResolver[byteCodesObj],
            nextMsgResolver[byteCodesObj])
registerMsg(snap1Protocol, 4, "getByteCodes", getByteCodesThunk,
            messagePrinter[getByteCodesObj], requestResolver[getByteCodesObj],
            nextMsgResolver[getByteCodesObj])
registerMsg(snap1Protocol, 7, "trieNodes", trieNodesThunk,
            messagePrinter[trieNodesObj], requestResolver[trieNodesObj],
            nextMsgResolver[trieNodesObj])
registerMsg(snap1Protocol, 6, "getTrieNodes", getTrieNodesThunk,
            messagePrinter[getTrieNodesObj], requestResolver[getTrieNodesObj],
            nextMsgResolver[getTrieNodesObj])
setEventHandlers(snap1Protocol, nil, nil)
registerProtocol(snap1Protocol)