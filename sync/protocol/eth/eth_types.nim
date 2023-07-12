{.push raises: [].}

import
  chronicles,sequtils,
  eth/[common, p2p, p2p/private/p2p_types, common/transaction],
  ../../types,
  ../../../core/tx_pool/tx_item

logScope:
  topics = "eth-wire"

type
  NewBlockHashesAnnounce* = object
    hash*: Hash256
    number*: BlockNumber

  ChainForkId* = object
    forkHash*: array[4, byte] # The RLP encoding must be exactly 4 bytes.
    forkNext*: BlockNumber    # The RLP encoding must be variable-length

  EthWireBase* = ref object of RootRef

  EthState* = object
    totalDifficulty*: DifficultyInt
    genesisHash*: Hash256
    bestBlockHash*: Hash256
    forkId*: ChainForkId

  EthPeerState* = ref object of RootRef
    initialized*: bool
    bestBlockHash*: Hash256
    bestDifficulty*: DifficultyInt

const
  maxStateFetch* = 384
  maxBodiesFetch* = 128
  maxReceiptsFetch* = 256
  maxHeadersFetch* = 192

proc notImplemented(name: string) =
  debug "Method not implemented", meth = name

method getStatus*(ctx: EthWireBase): EthState {.base, gcsafe, raises: [CatchableError].} =
  # notImplemented("getStatus")
  EthState(totalDifficulty:1.u256, genesisHash: Hash256.fromHex("0x0d21840abff46b96c84b2ac9e10e4f5cdaeb5693cb665db62a2f3b02d2d57b5b"), forkId: ChainForkId(forkHash:[byte(41),149,197,42], forkNext: 0.u256))

method getReceipts*(ctx: EthWireBase, hashes: openArray[Hash256]): seq[seq[Receipt]] {.base, gcsafe, raises: [CatchableError].} =
  notImplemented("getReceipts")

method getPooledTxs*(ctx: EthWireBase, hashes: openArray[Hash256]): seq[Transaction] {.base, gcsafe.} =
  notImplemented("getPooledTxs")

method getBlockBodies*(ctx: EthWireBase, hashes: openArray[Hash256]): seq[BlockBody] {.base, gcsafe, raises: [CatchableError].} =
  notImplemented("getBlockBodies")

method getBlockHeaders*(ctx: EthWireBase, req: BlocksRequest): seq[BlockHeader] {.base, gcsafe, raises: [CatchableError].} =
  notImplemented("getBlockHeaders")

method handleNewBlock*(ctx: EthWireBase, peer: Peer, blk: EthBlock, totalDifficulty: DifficultyInt) {.base, gcsafe, raises: [CatchableError].} =
  info "handleNewBlock", peer=peer, blk=blk, totalDifficulty=totalDifficulty
  notImplemented("handleNewBlock")

method handleAnnouncedTxs*(ctx: EthWireBase, peer: Peer, txs: openArray[Transaction]) {.base, gcsafe, raises: [CatchableError].} =
  info "handleAnnouncedTxs", peer=peer, txs=txs.len, txHashes = txs.mapIt(it.itemID())
  notImplemented("handleAnnouncedTxs")

method handleAnnouncedTxsHashes*(ctx: EthWireBase, peer: Peer, txHashes: openArray[Hash256]) {.base, gcsafe.} =
  {.gcsafe.}:
    notImplemented("handleAnnouncedTxsHashes")

method handleNewBlockHashes*(ctx: EthWireBase, peer: Peer, hashes: openArray[NewBlockHashesAnnounce]) {.base, gcsafe, raises: [CatchableError].} =
  notImplemented("handleNewBlockHashes")

method getStorageNodes*(ctx: EthWireBase, hashes: openArray[Hash256]): seq[Blob] {.base, gcsafe.} =
  notImplemented("getStorageNodes")

method handleNodeData*(ctx: EthWireBase, peer: Peer, data: openArray[Blob]) {.base, gcsafe.} =
  notImplemented("handleNodeData")
