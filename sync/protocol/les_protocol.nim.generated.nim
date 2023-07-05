
## Generated at line 220
type
  les* = object
template State*(PROTO: type les): type =
  ref[LesPeer:ObjectType]

template NetworkState*(PROTO: type les): type =
  ref[LesNetwork:ObjectType]

type
  statusObj* = object
    values*: seq[KeyValuePair]

template status*(PROTO: type les): type =
  statusObj

template msgProtocol*(MSG: type statusObj): type =
  les

template RecType*(MSG: type statusObj): untyped =
  statusObj

template msgId*(MSG: type statusObj): int =
  0

type
  announceObj* = object
    headHash*: KeccakHash
    headNumber*: BlockNumber
    headTotalDifficulty*: DifficultyInt
    reorgDepth*: BlockNumber
    values*: seq[KeyValuePair]
    announceType*: AnnounceType

template announce*(PROTO: type les): type =
  announceObj

template msgProtocol*(MSG: type announceObj): type =
  les

template RecType*(MSG: type announceObj): untyped =
  announceObj

template msgId*(MSG: type announceObj): int =
  1

type
  blockHeadersObj* = object
    bufValue*: BufValueInt
    blocks*: seq[BlockHeader]

template blockHeaders*(PROTO: type les): type =
  blockHeadersObj

template msgProtocol*(MSG: type blockHeadersObj): type =
  les

template RecType*(MSG: type blockHeadersObj): untyped =
  blockHeadersObj

template msgId*(MSG: type blockHeadersObj): int =
  3

type
  getBlockHeadersObj* = object
    req*: BlocksRequest

template getBlockHeaders*(PROTO: type les): type =
  getBlockHeadersObj

template msgProtocol*(MSG: type getBlockHeadersObj): type =
  les

template RecType*(MSG: type getBlockHeadersObj): untyped =
  getBlockHeadersObj

template msgId*(MSG: type getBlockHeadersObj): int =
  2

type
  blockBodiesObj* = object
    bufValue*: BufValueInt
    bodies*: seq[BlockBody]

template blockBodies*(PROTO: type les): type =
  blockBodiesObj

template msgProtocol*(MSG: type blockBodiesObj): type =
  les

template RecType*(MSG: type blockBodiesObj): untyped =
  blockBodiesObj

template msgId*(MSG: type blockBodiesObj): int =
  5

type
  getBlockBodiesObj* = object
    blocks*: seq[KeccakHash]

template getBlockBodies*(PROTO: type les): type =
  getBlockBodiesObj

template msgProtocol*(MSG: type getBlockBodiesObj): type =
  les

template RecType*(MSG: type getBlockBodiesObj): untyped =
  getBlockBodiesObj

template msgId*(MSG: type getBlockBodiesObj): int =
  4

type
  receiptsObj* = object
    bufValue*: BufValueInt
    receipts*: seq[Receipt]

template receipts*(PROTO: type les): type =
  receiptsObj

template msgProtocol*(MSG: type receiptsObj): type =
  les

template RecType*(MSG: type receiptsObj): untyped =
  receiptsObj

template msgId*(MSG: type receiptsObj): int =
  7

type
  getReceiptsObj* = object
    hashes*: seq[KeccakHash]

template getReceipts*(PROTO: type les): type =
  getReceiptsObj

template msgProtocol*(MSG: type getReceiptsObj): type =
  les

template RecType*(MSG: type getReceiptsObj): untyped =
  getReceiptsObj

template msgId*(MSG: type getReceiptsObj): int =
  6

type
  proofsObj* = object
    bufValue*: BufValueInt
    proofs*: seq[Blob]

template proofs*(PROTO: type les): type =
  proofsObj

template msgProtocol*(MSG: type proofsObj): type =
  les

template RecType*(MSG: type proofsObj): untyped =
  proofsObj

template msgId*(MSG: type proofsObj): int =
  9

type
  getProofsObj* = object
    proofs*: seq[ProofRequest]

template getProofs*(PROTO: type les): type =
  getProofsObj

template msgProtocol*(MSG: type getProofsObj): type =
  les

template RecType*(MSG: type getProofsObj): untyped =
  getProofsObj

template msgId*(MSG: type getProofsObj): int =
  8

type
  contractCodesObj* = object
    bufValue*: BufValueInt
    results*: seq[Blob]

template contractCodes*(PROTO: type les): type =
  contractCodesObj

template msgProtocol*(MSG: type contractCodesObj): type =
  les

template RecType*(MSG: type contractCodesObj): untyped =
  contractCodesObj

template msgId*(MSG: type contractCodesObj): int =
  11

type
  getContractCodesObj* = object
    reqs*: seq[ContractCodeRequest]

template getContractCodes*(PROTO: type les): type =
  getContractCodesObj

template msgProtocol*(MSG: type getContractCodesObj): type =
  les

template RecType*(MSG: type getContractCodesObj): untyped =
  getContractCodesObj

template msgId*(MSG: type getContractCodesObj): int =
  10

type
  headerProofsObj* = object
    bufValue*: BufValueInt
    proofs*: seq[Blob]

template headerProofs*(PROTO: type les): type =
  headerProofsObj

template msgProtocol*(MSG: type headerProofsObj): type =
  les

template RecType*(MSG: type headerProofsObj): untyped =
  headerProofsObj

template msgId*(MSG: type headerProofsObj): int =
  16

type
  getHeaderProofsObj* = object
    reqs*: seq[ProofRequest]

template getHeaderProofs*(PROTO: type les): type =
  getHeaderProofsObj

template msgProtocol*(MSG: type getHeaderProofsObj): type =
  les

template RecType*(MSG: type getHeaderProofsObj): untyped =
  getHeaderProofsObj

template msgId*(MSG: type getHeaderProofsObj): int =
  15

type
  helperTrieProofsObj* = object
    bufValue*: BufValueInt
    nodes*: seq[Blob]
    auxData*: seq[Blob]

template helperTrieProofs*(PROTO: type les): type =
  helperTrieProofsObj

template msgProtocol*(MSG: type helperTrieProofsObj): type =
  les

template RecType*(MSG: type helperTrieProofsObj): untyped =
  helperTrieProofsObj

template msgId*(MSG: type helperTrieProofsObj): int =
  18

type
  getHelperTrieProofsObj* = object
    reqs*: seq[HelperTrieProofRequest]

template getHelperTrieProofs*(PROTO: type les): type =
  getHelperTrieProofsObj

template msgProtocol*(MSG: type getHelperTrieProofsObj): type =
  les

template RecType*(MSG: type getHelperTrieProofsObj): untyped =
  getHelperTrieProofsObj

template msgId*(MSG: type getHelperTrieProofsObj): int =
  17

type
  txStatusObj* = object
    bufValue*: BufValueInt
    transactions*: seq[TransactionStatusMsg]

template txStatus*(PROTO: type les): type =
  txStatusObj

template msgProtocol*(MSG: type txStatusObj): type =
  les

template RecType*(MSG: type txStatusObj): untyped =
  txStatusObj

template msgId*(MSG: type txStatusObj): int =
  21

type
  sendTxV2Obj* = object
    transactions*: seq[Transaction]

template sendTxV2*(PROTO: type les): type =
  sendTxV2Obj

template msgProtocol*(MSG: type sendTxV2Obj): type =
  les

template RecType*(MSG: type sendTxV2Obj): untyped =
  sendTxV2Obj

template msgId*(MSG: type sendTxV2Obj): int =
  19

type
  getTxStatusObj* = object
    transactions*: seq[Transaction]

template getTxStatus*(PROTO: type les): type =
  getTxStatusObj

template msgProtocol*(MSG: type getTxStatusObj): type =
  les

template RecType*(MSG: type getTxStatusObj): untyped =
  getTxStatusObj

template msgId*(MSG: type getTxStatusObj): int =
  20

var lesProtocolObj = initProtocol("les", 2, createPeerState[Peer,
    ref[LesPeer:ObjectType]], createNetworkState[EthereumNode,
    ref[LesNetwork:ObjectType]])
var lesProtocol = addr lesProtocolObj
template protocolInfo*(PROTO: type les): auto =
  lesProtocol

proc statusRawSender(peerOrResponder: Peer; values: openArray[KeyValuePair];
                     timeout: Duration = milliseconds(10000'i64)): Future[void] {.
    gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 0
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 0)
  append(writer, perPeerMsgId)
  append(writer, values)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template status*(p: Peer; values: openArray[KeyValuePair];
                 timeout: Duration = milliseconds(10000'i64)): Future[statusObj] =
  let peer_11374954640 = p
  let sendingFuture`gensym65 = statusRawSender(peer, values)
  handshakeImpl(peer_11374954640, sendingFuture`gensym65,
                nextMsg(peer_11374954640, statusObj), timeout)

proc announce*(peerOrResponder: Peer; headHash: KeccakHash;
               headNumber: BlockNumber; headTotalDifficulty: DifficultyInt;
               reorgDepth: BlockNumber; values: openArray[KeyValuePair];
               announceType: AnnounceType): Future[void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 1
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 1)
  append(writer, perPeerMsgId)
  startList(writer, 6)
  append(writer, headHash)
  append(writer, headNumber)
  append(writer, headTotalDifficulty)
  append(writer, reorgDepth)
  append(writer, values)
  append(writer, announceType)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

proc blockHeaders*(peerOrResponder: ResponderWithId[blockHeadersObj];
                   bufValue: BufValueInt; blocks: openArray[BlockHeader]): Future[
    void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 3
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 3)
  append(writer, perPeerMsgId)
  startList(writer, 3)
  append(writer, peerOrResponder.reqId)
  append(writer, bufValue)
  append(writer, blocks)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym81: ResponderWithId[blockHeadersObj];
               args`gensym81: varargs[untyped]): auto =
  blockHeaders(r`gensym81, args`gensym81)

proc getBlockHeaders*(peerOrResponder: Peer; req: BlocksRequest;
                      timeout: Duration = milliseconds(10000'i64)): Future[
    Option[blockHeadersObj]] {.outgoingRequestDecorator, gcsafe, costQuantity(
    req.maxResults.int, max = maxHeadersFetch).} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 2
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 2)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, req)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc blockBodies*(peerOrResponder: ResponderWithId[blockBodiesObj];
                  bufValue: BufValueInt; bodies: openArray[BlockBody]): Future[
    void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 5
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 5)
  append(writer, perPeerMsgId)
  startList(writer, 3)
  append(writer, peerOrResponder.reqId)
  append(writer, bufValue)
  append(writer, bodies)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym99: ResponderWithId[blockBodiesObj];
               args`gensym99: varargs[untyped]): auto =
  blockBodies(r`gensym99, args`gensym99)

proc getBlockBodies*(peerOrResponder: Peer; blocks: openArray[KeccakHash];
                     timeout: Duration = milliseconds(10000'i64)): Future[
    Option[blockBodiesObj]] {.outgoingRequestDecorator, gcsafe,
                              costQuantity(blocks.len, max = maxBodiesFetch),
                              gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 4
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 4)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, blocks)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc receipts*(peerOrResponder: ResponderWithId[receiptsObj];
               bufValue: BufValueInt; receipts: openArray[Receipt]): Future[void] {.
    gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 7
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 7)
  append(writer, perPeerMsgId)
  startList(writer, 3)
  append(writer, peerOrResponder.reqId)
  append(writer, bufValue)
  append(writer, receipts)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym117: ResponderWithId[receiptsObj];
               args`gensym117: varargs[untyped]): auto =
  receipts(r`gensym117, args`gensym117)

proc getReceipts*(peerOrResponder: Peer; hashes: openArray[KeccakHash];
                  timeout: Duration = milliseconds(10000'i64)): Future[
    Option[receiptsObj]] {.outgoingRequestDecorator, gcsafe,
                           costQuantity(hashes.len, max = maxReceiptsFetch).} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 6
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 6)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, hashes)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc proofs*(peerOrResponder: ResponderWithId[proofsObj]; bufValue: BufValueInt;
             proofs: openArray[Blob]): Future[void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 9
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 9)
  append(writer, perPeerMsgId)
  startList(writer, 3)
  append(writer, peerOrResponder.reqId)
  append(writer, bufValue)
  append(writer, proofs)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym135: ResponderWithId[proofsObj];
               args`gensym135: varargs[untyped]): auto =
  proofs(r`gensym135, args`gensym135)

proc getProofs*(peerOrResponder: Peer; proofs: openArray[ProofRequest];
                timeout: Duration = milliseconds(10000'i64)): Future[
    Option[proofsObj]] {.outgoingRequestDecorator, gcsafe,
                         costQuantity(proofs.len, max = maxProofsFetch).} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 8
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 8)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, proofs)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc contractCodes*(peerOrResponder: ResponderWithId[contractCodesObj];
                    bufValue: BufValueInt; results: seq[Blob]): Future[void] {.
    gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 11
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 11)
  append(writer, perPeerMsgId)
  startList(writer, 3)
  append(writer, peerOrResponder.reqId)
  append(writer, bufValue)
  append(writer, results)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym153: ResponderWithId[contractCodesObj];
               args`gensym153: varargs[untyped]): auto =
  contractCodes(r`gensym153, args`gensym153)

proc getContractCodes*(peerOrResponder: Peer; reqs: seq[ContractCodeRequest];
                       timeout: Duration = milliseconds(10000'i64)): Future[
    Option[contractCodesObj]] {.outgoingRequestDecorator, gcsafe,
                                costQuantity(reqs.len, max = maxCodeFetch).} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 10
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 10)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, reqs)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc headerProofs*(peerOrResponder: ResponderWithId[headerProofsObj];
                   bufValue: BufValueInt; proofs: openArray[Blob]): Future[void] {.
    gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 16
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 16)
  append(writer, perPeerMsgId)
  startList(writer, 3)
  append(writer, peerOrResponder.reqId)
  append(writer, bufValue)
  append(writer, proofs)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym171: ResponderWithId[headerProofsObj];
               args`gensym171: varargs[untyped]): auto =
  headerProofs(r`gensym171, args`gensym171)

proc getHeaderProofs*(peerOrResponder: Peer; reqs: openArray[ProofRequest];
                      timeout: Duration = milliseconds(10000'i64)): Future[
    Option[headerProofsObj]] {.outgoingRequestDecorator, gcsafe, costQuantity(
    reqs.len, max = maxHeaderProofsFetch).} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 15
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 15)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, reqs)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc helperTrieProofs*(peerOrResponder: ResponderWithId[helperTrieProofsObj];
                       bufValue: BufValueInt; nodes: seq[Blob];
                       auxData: seq[Blob]): Future[void] {.gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 18
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 18)
  append(writer, perPeerMsgId)
  startList(writer, 4)
  append(writer, peerOrResponder.reqId)
  append(writer, bufValue)
  append(writer, nodes)
  append(writer, auxData)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym190: ResponderWithId[helperTrieProofsObj];
               args`gensym190: varargs[untyped]): auto =
  helperTrieProofs(r`gensym190, args`gensym190)

proc getHelperTrieProofs*(peerOrResponder: Peer;
                          reqs: openArray[HelperTrieProofRequest];
                          timeout: Duration = milliseconds(10000'i64)): Future[
    Option[helperTrieProofsObj]] {.outgoingRequestDecorator, gcsafe,
                                   costQuantity(reqs.len, max = maxProofsFetch).} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 17
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 17)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, reqs)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc txStatus*(peerOrResponder: ResponderWithId[txStatusObj];
               bufValue: BufValueInt;
               transactions: openArray[TransactionStatusMsg]): Future[void] {.
    gcsafe.} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 21
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 21)
  append(writer, perPeerMsgId)
  startList(writer, 3)
  append(writer, peerOrResponder.reqId)
  append(writer, bufValue)
  append(writer, transactions)
  let msgBytes = finish(writer)
  return sendMsg(peer, msgBytes)

template send*(r`gensym208: ResponderWithId[txStatusObj];
               args`gensym208: varargs[untyped]): auto =
  txStatus(r`gensym208, args`gensym208)

proc sendTxV2*(peerOrResponder: Peer; transactions: openArray[Transaction];
               timeout: Duration = milliseconds(10000'i64)): Future[
    Option[txStatusObj]] {.outgoingRequestDecorator, gcsafe, costQuantity(
    transactions.len, max = maxTransactionsFetch).} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 19
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 19)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 2)
  append(writer, reqId)
  append(writer, transactions)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc getTxStatus*(peerOrResponder: Peer; transactions: openArray[Transaction];
                  timeout: Duration = milliseconds(10000'i64)): Future[
    Option[txStatusObj]] {.outgoingRequestDecorator, gcsafe, costQuantity(
    transactions.len, max = maxTransactionsFetch).} =
  let peer = getPeer(peerOrResponder)
  var writer = initRlpWriter()
  const
    perProtocolMsgId = 20
  let perPeerMsgId = perPeerMsgIdImpl(peer, lesProtocol, 20)
  append(writer, perPeerMsgId)
  startList(writer, 2)
  initFuture result
  let reqId = registerRequest(peer, timeout, result, perPeerMsgId + 1)
  append(writer, reqId)
  append(writer, transactions)
  let msgBytes = finish(writer)
  linkSendFailureToReqFuture(sendMsg(peer, msgBytes), result)

proc announceUserHandler(peer: Peer; headHash: KeccakHash;
                         headNumber: BlockNumber;
                         headTotalDifficulty: DifficultyInt;
                         reorgDepth: BlockNumber; values: seq[KeyValuePair];
                         announceType: AnnounceType) {.gcsafe, async.} =
  type
    CurrentProtocol = les
  const
    perProtocolMsgId = 1
  template state(peer: Peer): ref[LesPeer:ObjectType] =
    cast[ref[LesPeer:ObjectType]](getState(peer, lesProtocol))

  template networkState(peer: Peer): ref[LesNetwork:ObjectType] =
    cast[ref[LesNetwork:ObjectType]](getNetworkState(peer.network, lesProtocol))

  if peer.state.announceType == AnnounceType.None:
    error "unexpected announce message", peer
    return
  if announceType == AnnounceType.Signed:
    let signature = values.getValue(keyAnnounceSignature, Blob)
    if signature.isNone:
      error "missing announce signature"
      return
    let sig = Signature.fromRaw(signature.get).tryGet()
    let sigMsg = rlp.encodeList(headHash, headNumber, headTotalDifficulty)
    let signerKey = recover(sig, sigMsg).tryGet()
    if signerKey.toNodeId != peer.remote.id:
      error "invalid announce signature"
      return

proc getBlockHeadersUserHandler(peer: Peer; reqId: int; req: BlocksRequest) {.
    incomingRequestDecorator,
    costQuantity(req.maxResults.int, max = maxHeadersFetch), gcsafe, async.} =
  type
    CurrentProtocol = les
  const
    perProtocolMsgId = 2
  template state(peer: Peer): ref[LesPeer:ObjectType] =
    cast[ref[LesPeer:ObjectType]](getState(peer, lesProtocol))

  template networkState(peer: Peer): ref[LesNetwork:ObjectType] =
    cast[ref[LesNetwork:ObjectType]](getNetworkState(peer.network, lesProtocol))

  var response = init(ResponderWithId[blockHeadersObj], peer, reqId)
  let ctx = peer.networkState()
  let headers = ctx.getBlockHeaders(req)
  await response.send(updateBV(), headers)

proc getBlockBodiesUserHandler(peer: Peer; reqId: int; blocks: seq[KeccakHash]) {.
    incomingRequestDecorator, costQuantity(blocks.len, max = maxBodiesFetch),
    gcsafe, gcsafe, async.} =
  type
    CurrentProtocol = les
  const
    perProtocolMsgId = 4
  template state(peer: Peer): ref[LesPeer:ObjectType] =
    cast[ref[LesPeer:ObjectType]](getState(peer, lesProtocol))

  template networkState(peer: Peer): ref[LesNetwork:ObjectType] =
    cast[ref[LesNetwork:ObjectType]](getNetworkState(peer.network, lesProtocol))

  var response = init(ResponderWithId[blockBodiesObj], peer, reqId)
  let ctx = peer.networkState()
  let blocks = ctx.getBlockBodies(blocks)
  await response.send(updateBV(), blocks)

proc getReceiptsUserHandler(peer: Peer; reqId: int; hashes: seq[KeccakHash]) {.
    incomingRequestDecorator, costQuantity(hashes.len, max = maxReceiptsFetch),
    gcsafe, async.} =
  type
    CurrentProtocol = les
  const
    perProtocolMsgId = 6
  template state(peer: Peer): ref[LesPeer:ObjectType] =
    cast[ref[LesPeer:ObjectType]](getState(peer, lesProtocol))

  template networkState(peer: Peer): ref[LesNetwork:ObjectType] =
    cast[ref[LesNetwork:ObjectType]](getNetworkState(peer.network, lesProtocol))

  var response = init(ResponderWithId[receiptsObj], peer, reqId)
  let ctx = peer.networkState()
  let receipts = ctx.getReceipts(hashes)
  await response.send(updateBV(), receipts)

proc getProofsUserHandler(peer: Peer; reqId: int; proofs: seq[ProofRequest]) {.
    incomingRequestDecorator, costQuantity(proofs.len, max = maxProofsFetch),
    gcsafe, async.} =
  type
    CurrentProtocol = les
  const
    perProtocolMsgId = 8
  template state(peer: Peer): ref[LesPeer:ObjectType] =
    cast[ref[LesPeer:ObjectType]](getState(peer, lesProtocol))

  template networkState(peer: Peer): ref[LesNetwork:ObjectType] =
    cast[ref[LesNetwork:ObjectType]](getNetworkState(peer.network, lesProtocol))

  var response = init(ResponderWithId[proofsObj], peer, reqId)
  let ctx = peer.networkState()
  let proofs = ctx.getProofs(proofs)
  await response.send(updateBV(), proofs)

proc getContractCodesUserHandler(peer: Peer; reqId: int;
                                 reqs: seq[ContractCodeRequest]) {.
    incomingRequestDecorator, costQuantity(reqs.len, max = maxCodeFetch),
    gcsafe, async.} =
  type
    CurrentProtocol = les
  const
    perProtocolMsgId = 10
  template state(peer: Peer): ref[LesPeer:ObjectType] =
    cast[ref[LesPeer:ObjectType]](getState(peer, lesProtocol))

  template networkState(peer: Peer): ref[LesNetwork:ObjectType] =
    cast[ref[LesNetwork:ObjectType]](getNetworkState(peer.network, lesProtocol))

  var response = init(ResponderWithId[contractCodesObj], peer, reqId)
  let ctx = peer.networkState()
  let results = ctx.getContractCodes(reqs)
  await response.send(updateBV(), results)

proc getHeaderProofsUserHandler(peer: Peer; reqId: int; reqs: seq[ProofRequest]) {.
    incomingRequestDecorator,
    costQuantity(reqs.len, max = maxHeaderProofsFetch), gcsafe, async.} =
  type
    CurrentProtocol = les
  const
    perProtocolMsgId = 15
  template state(peer: Peer): ref[LesPeer:ObjectType] =
    cast[ref[LesPeer:ObjectType]](getState(peer, lesProtocol))

  template networkState(peer: Peer): ref[LesNetwork:ObjectType] =
    cast[ref[LesNetwork:ObjectType]](getNetworkState(peer.network, lesProtocol))

  var response = init(ResponderWithId[headerProofsObj], peer, reqId)
  let ctx = peer.networkState()
  let proofs = ctx.getHeaderProofs(reqs)
  await response.send(updateBV(), proofs)

proc getHelperTrieProofsUserHandler(peer: Peer; reqId: int;
                                    reqs: seq[HelperTrieProofRequest]) {.
    incomingRequestDecorator, costQuantity(reqs.len, max = maxProofsFetch),
    gcsafe, async.} =
  type
    CurrentProtocol = les
  const
    perProtocolMsgId = 17
  template state(peer: Peer): ref[LesPeer:ObjectType] =
    cast[ref[LesPeer:ObjectType]](getState(peer, lesProtocol))

  template networkState(peer: Peer): ref[LesNetwork:ObjectType] =
    cast[ref[LesNetwork:ObjectType]](getNetworkState(peer.network, lesProtocol))

  var response = init(ResponderWithId[helperTrieProofsObj], peer, reqId)
  let ctx = peer.networkState()
  var nodes, auxData: seq[Blob]
  ctx.getHelperTrieProofs(reqs, nodes, auxData)
  await response.send(updateBV(), nodes, auxData)

proc sendTxV2UserHandler(peer: Peer; reqId: int; transactions: seq[Transaction]) {.
    incomingRequestDecorator,
    costQuantity(transactions.len, max = maxTransactionsFetch), gcsafe, async.} =
  type
    CurrentProtocol = les
  const
    perProtocolMsgId = 19
  template state(peer: Peer): ref[LesPeer:ObjectType] =
    cast[ref[LesPeer:ObjectType]](getState(peer, lesProtocol))

  template networkState(peer: Peer): ref[LesNetwork:ObjectType] =
    cast[ref[LesNetwork:ObjectType]](getNetworkState(peer.network, lesProtocol))

  var response = init(ResponderWithId[txStatusObj], peer, reqId)
  let ctx = peer.networkState()
  var results: seq[TransactionStatusMsg]
  for t in transactions:
    let hash = t.rlpHash
    var s = ctx.getTransactionStatus(hash)
    if s.status == TransactionStatus.Unknown:
      ctx.addTransactions([t])
      s = ctx.getTransactionStatus(hash)
    results.add s
  await response.send(updateBV(), results)

proc getTxStatusUserHandler(peer: Peer; reqId: int;
                            transactions: seq[Transaction]) {.
    incomingRequestDecorator,
    costQuantity(transactions.len, max = maxTransactionsFetch), gcsafe, async.} =
  type
    CurrentProtocol = les
  const
    perProtocolMsgId = 20
  template state(peer: Peer): ref[LesPeer:ObjectType] =
    cast[ref[LesPeer:ObjectType]](getState(peer, lesProtocol))

  template networkState(peer: Peer): ref[LesNetwork:ObjectType] =
    cast[ref[LesNetwork:ObjectType]](getNetworkState(peer.network, lesProtocol))

  var response = init(ResponderWithId[txStatusObj], peer, reqId)
  let ctx = peer.networkState()
  var results: seq[TransactionStatusMsg]
  for t in transactions:
    results.add ctx.getTransactionStatus(t.rlpHash)
  await response.send(updateBV(), results)

proc statusThunk(peer: Peer; _`gensym60: int; data`gensym60: Rlp) {.async,
    gcsafe, raises: [RlpError].} =
  var rlp = data`gensym60
  var msg {.noinit.}: statusObj
  msg.values = checkedRlpRead(peer, rlp, openArray[KeyValuePair])
  
proc announceThunk(peer: Peer; _`gensym72: int; data`gensym72: Rlp) {.async,
    gcsafe, raises: [RlpError].} =
  var rlp = data`gensym72
  var msg {.noinit.}: announceObj
  tryEnterList(rlp)
  msg.headHash = checkedRlpRead(peer, rlp, KeccakHash)
  msg.headNumber = checkedRlpRead(peer, rlp, BlockNumber)
  msg.headTotalDifficulty = checkedRlpRead(peer, rlp, DifficultyInt)
  msg.reorgDepth = checkedRlpRead(peer, rlp, BlockNumber)
  msg.values = checkedRlpRead(peer, rlp, openArray[KeyValuePair])
  msg.announceType = checkedRlpRead(peer, rlp, AnnounceType)
  await(announceUserHandler(peer, msg.headHash, msg.headNumber,
                            msg.headTotalDifficulty, msg.reorgDepth, msg.values,
                            msg.announceType))
  
proc blockHeadersThunk(peer: Peer; _`gensym80: int; data`gensym80: Rlp) {.
    incomingResponseDecorator, async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym80
  var msg {.noinit.}: blockHeadersObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.bufValue = checkedRlpRead(peer, rlp, BufValueInt)
  msg.blocks = checkedRlpRead(peer, rlp, openArray[BlockHeader])
  resolveResponseFuture(peer, perPeerMsgId(peer, blockHeadersObj), addr(msg),
                        reqId)

proc getBlockHeadersThunk(peer: Peer; _`gensym90: int; data`gensym90: Rlp) {.
    async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym90
  var msg {.noinit.}: getBlockHeadersObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.req = checkedRlpRead(peer, rlp, BlocksRequest)
  await(getBlockHeadersUserHandler(peer, reqId, msg.req))
  
proc blockBodiesThunk(peer: Peer; _`gensym98: int; data`gensym98: Rlp) {.
    incomingResponseDecorator, async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym98
  var msg {.noinit.}: blockBodiesObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.bufValue = checkedRlpRead(peer, rlp, BufValueInt)
  msg.bodies = checkedRlpRead(peer, rlp, openArray[BlockBody])
  resolveResponseFuture(peer, perPeerMsgId(peer, blockBodiesObj), addr(msg),
                        reqId)

proc getBlockBodiesThunk(peer: Peer; _`gensym108: int; data`gensym108: Rlp) {.
    async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym108
  var msg {.noinit.}: getBlockBodiesObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.blocks = checkedRlpRead(peer, rlp, openArray[KeccakHash])
  await(getBlockBodiesUserHandler(peer, reqId, msg.blocks))
  
proc receiptsThunk(peer: Peer; _`gensym116: int; data`gensym116: Rlp) {.
    incomingResponseDecorator, async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym116
  var msg {.noinit.}: receiptsObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.bufValue = checkedRlpRead(peer, rlp, BufValueInt)
  msg.receipts = checkedRlpRead(peer, rlp, openArray[Receipt])
  resolveResponseFuture(peer, perPeerMsgId(peer, receiptsObj), addr(msg), reqId)

proc getReceiptsThunk(peer: Peer; _`gensym126: int; data`gensym126: Rlp) {.
    async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym126
  var msg {.noinit.}: getReceiptsObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.hashes = checkedRlpRead(peer, rlp, openArray[KeccakHash])
  await(getReceiptsUserHandler(peer, reqId, msg.hashes))
  
proc proofsThunk(peer: Peer; _`gensym134: int; data`gensym134: Rlp) {.
    incomingResponseDecorator, async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym134
  var msg {.noinit.}: proofsObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.bufValue = checkedRlpRead(peer, rlp, BufValueInt)
  msg.proofs = checkedRlpRead(peer, rlp, openArray[Blob])
  resolveResponseFuture(peer, perPeerMsgId(peer, proofsObj), addr(msg), reqId)

proc getProofsThunk(peer: Peer; _`gensym144: int; data`gensym144: Rlp) {.async,
    gcsafe, raises: [RlpError].} =
  var rlp = data`gensym144
  var msg {.noinit.}: getProofsObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.proofs = checkedRlpRead(peer, rlp, openArray[ProofRequest])
  await(getProofsUserHandler(peer, reqId, msg.proofs))
  
proc contractCodesThunk(peer: Peer; _`gensym152: int; data`gensym152: Rlp) {.
    incomingResponseDecorator, async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym152
  var msg {.noinit.}: contractCodesObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.bufValue = checkedRlpRead(peer, rlp, BufValueInt)
  msg.results = checkedRlpRead(peer, rlp, seq[Blob])
  resolveResponseFuture(peer, perPeerMsgId(peer, contractCodesObj), addr(msg),
                        reqId)

proc getContractCodesThunk(peer: Peer; _`gensym162: int; data`gensym162: Rlp) {.
    async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym162
  var msg {.noinit.}: getContractCodesObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.reqs = checkedRlpRead(peer, rlp, seq[ContractCodeRequest])
  await(getContractCodesUserHandler(peer, reqId, msg.reqs))
  
proc headerProofsThunk(peer: Peer; _`gensym170: int; data`gensym170: Rlp) {.
    incomingResponseDecorator, async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym170
  var msg {.noinit.}: headerProofsObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.bufValue = checkedRlpRead(peer, rlp, BufValueInt)
  msg.proofs = checkedRlpRead(peer, rlp, openArray[Blob])
  resolveResponseFuture(peer, perPeerMsgId(peer, headerProofsObj), addr(msg),
                        reqId)

proc getHeaderProofsThunk(peer: Peer; _`gensym180: int; data`gensym180: Rlp) {.
    async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym180
  var msg {.noinit.}: getHeaderProofsObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.reqs = checkedRlpRead(peer, rlp, openArray[ProofRequest])
  await(getHeaderProofsUserHandler(peer, reqId, msg.reqs))
  
proc helperTrieProofsThunk(peer: Peer; _`gensym189: int; data`gensym189: Rlp) {.
    incomingResponseDecorator, async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym189
  var msg {.noinit.}: helperTrieProofsObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.bufValue = checkedRlpRead(peer, rlp, BufValueInt)
  msg.nodes = checkedRlpRead(peer, rlp, seq[Blob])
  msg.auxData = checkedRlpRead(peer, rlp, seq[Blob])
  resolveResponseFuture(peer, perPeerMsgId(peer, helperTrieProofsObj),
                        addr(msg), reqId)

proc getHelperTrieProofsThunk(peer: Peer; _`gensym199: int; data`gensym199: Rlp) {.
    async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym199
  var msg {.noinit.}: getHelperTrieProofsObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.reqs = checkedRlpRead(peer, rlp, openArray[HelperTrieProofRequest])
  await(getHelperTrieProofsUserHandler(peer, reqId, msg.reqs))
  
proc txStatusThunk(peer: Peer; _`gensym207: int; data`gensym207: Rlp) {.
    incomingResponseDecorator, async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym207
  var msg {.noinit.}: txStatusObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.bufValue = checkedRlpRead(peer, rlp, BufValueInt)
  msg.transactions = checkedRlpRead(peer, rlp, openArray[TransactionStatusMsg])
  resolveResponseFuture(peer, perPeerMsgId(peer, txStatusObj), addr(msg), reqId)

proc sendTxV2Thunk(peer: Peer; _`gensym217: int; data`gensym217: Rlp) {.async,
    gcsafe, raises: [RlpError].} =
  var rlp = data`gensym217
  var msg {.noinit.}: sendTxV2Obj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.transactions = checkedRlpRead(peer, rlp, openArray[Transaction])
  await(sendTxV2UserHandler(peer, reqId, msg.transactions))
  
proc getTxStatusThunk(peer: Peer; _`gensym226: int; data`gensym226: Rlp) {.
    async, gcsafe, raises: [RlpError].} =
  var rlp = data`gensym226
  var msg {.noinit.}: getTxStatusObj
  tryEnterList(rlp)
  let reqId = read(rlp, int)
  msg.transactions = checkedRlpRead(peer, rlp, openArray[Transaction])
  await(getTxStatusUserHandler(peer, reqId, msg.transactions))
  
registerMsg(lesProtocol, 0, "status", statusThunk, messagePrinter[statusObj],
            requestResolver[statusObj], nextMsgResolver[statusObj])
registerMsg(lesProtocol, 1, "announce", announceThunk,
            messagePrinter[announceObj], requestResolver[announceObj],
            nextMsgResolver[announceObj])
registerMsg(lesProtocol, 3, "blockHeaders", blockHeadersThunk,
            messagePrinter[blockHeadersObj], requestResolver[blockHeadersObj],
            nextMsgResolver[blockHeadersObj])
registerMsg(lesProtocol, 2, "getBlockHeaders", getBlockHeadersThunk,
            messagePrinter[getBlockHeadersObj],
            requestResolver[getBlockHeadersObj],
            nextMsgResolver[getBlockHeadersObj])
registerMsg(lesProtocol, 5, "blockBodies", blockBodiesThunk,
            messagePrinter[blockBodiesObj], requestResolver[blockBodiesObj],
            nextMsgResolver[blockBodiesObj])
registerMsg(lesProtocol, 4, "getBlockBodies", getBlockBodiesThunk,
            messagePrinter[getBlockBodiesObj],
            requestResolver[getBlockBodiesObj],
            nextMsgResolver[getBlockBodiesObj])
registerMsg(lesProtocol, 7, "receipts", receiptsThunk,
            messagePrinter[receiptsObj], requestResolver[receiptsObj],
            nextMsgResolver[receiptsObj])
registerMsg(lesProtocol, 6, "getReceipts", getReceiptsThunk,
            messagePrinter[getReceiptsObj], requestResolver[getReceiptsObj],
            nextMsgResolver[getReceiptsObj])
registerMsg(lesProtocol, 9, "proofs", proofsThunk, messagePrinter[proofsObj],
            requestResolver[proofsObj], nextMsgResolver[proofsObj])
registerMsg(lesProtocol, 8, "getProofs", getProofsThunk,
            messagePrinter[getProofsObj], requestResolver[getProofsObj],
            nextMsgResolver[getProofsObj])
registerMsg(lesProtocol, 11, "contractCodes", contractCodesThunk,
            messagePrinter[contractCodesObj], requestResolver[contractCodesObj],
            nextMsgResolver[contractCodesObj])
registerMsg(lesProtocol, 10, "getContractCodes", getContractCodesThunk,
            messagePrinter[getContractCodesObj],
            requestResolver[getContractCodesObj],
            nextMsgResolver[getContractCodesObj])
registerMsg(lesProtocol, 16, "headerProofs", headerProofsThunk,
            messagePrinter[headerProofsObj], requestResolver[headerProofsObj],
            nextMsgResolver[headerProofsObj])
registerMsg(lesProtocol, 15, "getHeaderProofs", getHeaderProofsThunk,
            messagePrinter[getHeaderProofsObj],
            requestResolver[getHeaderProofsObj],
            nextMsgResolver[getHeaderProofsObj])
registerMsg(lesProtocol, 18, "helperTrieProofs", helperTrieProofsThunk,
            messagePrinter[helperTrieProofsObj],
            requestResolver[helperTrieProofsObj],
            nextMsgResolver[helperTrieProofsObj])
registerMsg(lesProtocol, 17, "getHelperTrieProofs", getHelperTrieProofsThunk,
            messagePrinter[getHelperTrieProofsObj],
            requestResolver[getHelperTrieProofsObj],
            nextMsgResolver[getHelperTrieProofsObj])
registerMsg(lesProtocol, 21, "txStatus", txStatusThunk,
            messagePrinter[txStatusObj], requestResolver[txStatusObj],
            nextMsgResolver[txStatusObj])
registerMsg(lesProtocol, 19, "sendTxV2", sendTxV2Thunk,
            messagePrinter[sendTxV2Obj], requestResolver[sendTxV2Obj],
            nextMsgResolver[sendTxV2Obj])
registerMsg(lesProtocol, 20, "getTxStatus", getTxStatusThunk,
            messagePrinter[getTxStatusObj], requestResolver[getTxStatusObj],
            nextMsgResolver[getTxStatusObj])
proc lesPeerConnected(peer: Peer) {.gcsafe, async.} =
  type
    CurrentProtocol = les
  template state(peer: Peer): ref[LesPeer:ObjectType] =
    cast[ref[LesPeer:ObjectType]](getState(peer, lesProtocol))

  template networkState(peer: Peer): ref[LesNetwork:ObjectType] =
    cast[ref[LesNetwork:ObjectType]](getNetworkState(peer.network, lesProtocol))

  let
    network = peer.network
    lesPeer = peer.state
    lesNetwork = peer.networkState
    status = lesNetwork.getStatus()
  template `=>`(k, v: untyped): untyped =
    KeyValuePair(key: k, value: rlp.encode(v))

  var lesProperties = @[keyProtocolVersion => lesVersion,
                        keyNetworkId => network.networkId,
                        keyHeadTotalDifficulty => status.difficulty,
                        keyHeadHash => status.blockHash,
                        keyHeadNumber => status.blockNumber,
                        keyGenesisHash => status.genesisHash]
  lesPeer.remoteReqCosts = currentRequestsCosts(lesNetwork, les.protocolInfo)
  if lesNetwork.areWeServingData:
    lesProperties.add [keyServeChainSince => 0, keyServeStateSince => 0,
                       keyFlowControlBL => lesNetwork.bufferLimit,
                       keyFlowControlMRR => lesNetwork.minRechargingRate,
                       keyFlowControlMRC => lesPeer.remoteReqCosts]
  if lesNetwork.areWeRequestingData:
    lesProperties.add(keyAnnounceType => lesNetwork.ourAnnounceType)
  let
    s = await peer.status(lesProperties, timeout = chronos.seconds(10))
    peerNetworkId = s.values.getRequiredValue(keyNetworkId, NetworkId)
    peerGenesisHash = s.values.getRequiredValue(keyGenesisHash, KeccakHash)
    peerLesVersion = s.values.getRequiredValue(keyProtocolVersion, uint)
  template requireCompatibility(peerVar, localVar, varName: untyped) =
    if localVar != peerVar:
      raise newException(HandshakeError, "Incompatibility detected! $1 mismatch ($2 != $3)" %
          [varName, $localVar, $peerVar])

  requireCompatibility(peerLesVersion, uint(lesVersion), "les version")
  requireCompatibility(peerNetworkId, network.networkId, "network id")
  requireCompatibility(peerGenesisHash, status.genesisHash, "genesis hash")
  template `:=`(lhs, key) =
    lhs = s.values.getRequiredValue(key, type(lhs))

  lesPeer.bestBlockHash := keyHeadHash
  lesPeer.bestBlockNumber := keyHeadNumber
  lesPeer.bestDifficulty := keyHeadTotalDifficulty
  let peerAnnounceType = s.values.getValue(keyAnnounceType, AnnounceType)
  if peerAnnounceType.isSome:
    lesPeer.isClient = true
    lesPeer.announceType = peerAnnounceType.get
  else:
    lesPeer.announceType = AnnounceType.Simple
    lesPeer.hasChainSince := keyServeChainSince
    lesPeer.hasStateSince := keyServeStateSince
    lesPeer.relaysTransactions := keyRelaysTransactions
    lesPeer.localFlowState.bufLimit := keyFlowControlBL
    lesPeer.localFlowState.minRecharge := keyFlowControlMRR
    lesPeer.localReqCosts := keyFlowControlMRC
  lesNetwork.addPeer lesPeer

proc lesPeerDisconnected(peer: Peer; reason: DisconnectionReason) {.gcsafe,
    gcsafe, async.} =
  type
    CurrentProtocol = les
  template state(peer: Peer): ref[LesPeer:ObjectType] =
    cast[ref[LesPeer:ObjectType]](getState(peer, lesProtocol))

  template networkState(peer: Peer): ref[LesNetwork:ObjectType] =
    cast[ref[LesNetwork:ObjectType]](getNetworkState(peer.network, lesProtocol))

  peer.networkState.removePeer peer.state

setEventHandlers(lesProtocol, lesPeerConnected, lesPeerDisconnected)
registerProtocol(lesProtocol)