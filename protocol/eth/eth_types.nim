
{.push raises: [].}

import
  chronicles,
  eth/[common, p2p, p2p/private/p2p_types],
  ../types

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

method getStatus*(ctx: EthWireBase): EthState
    {.base, gcsafe, raises: [CatchableError].} =
  notImplemented("getStatus")

method getReceipts*(ctx: EthWireBase, hashes: openArray[Hash256]): seq[seq[Receipt]]
    {.base, gcsafe, raises: [CatchableError].} =
  notImplemented("getReceipts")

method getPooledTxs*(ctx: EthWireBase, hashes: openArray[Hash256]): seq[Transaction] {.base, gcsafe.} =
  notImplemented("getPooledTxs")

method getBlockBodies*(ctx: EthWireBase, hashes: openArray[Hash256]): seq[BlockBody] {.base, gcsafe, raises: [CatchableError].} =
  notImplemented("getBlockBodies")

method getBlockHeaders*(ctx: EthWireBase, req: BlocksRequest): seq[BlockHeader]
    {.base, gcsafe, raises: [CatchableError].} =
  notImplemented("getBlockHeaders")

method handleNewBlock*(ctx: EthWireBase, peer: Peer, blk: EthBlock, totalDifficulty: DifficultyInt)
    {.base, gcsafe, raises: [CatchableError].} =
  notImplemented("handleNewBlock")

method handleAnnouncedTxs*(ctx: EthWireBase, peer: Peer, txs: openArray[Transaction])
    {.base, gcsafe, raises: [CatchableError].} =
  notImplemented("handleAnnouncedTxs")

method handleAnnouncedTxsHashes*(ctx: EthWireBase, peer: Peer, txHashes: openArray[Hash256]) {.base, gcsafe.} =
  notImplemented("handleAnnouncedTxsHashes")

method handleNewBlockHashes*(ctx: EthWireBase, peer: Peer, hashes: openArray[NewBlockHashesAnnounce])
    {.base, gcsafe, raises: [CatchableError].} =
  notImplemented("handleNewBlockHashes")

method getStorageNodes*(ctx: EthWireBase, hashes: openArray[Hash256]): seq[Blob] {.base, gcsafe.} =
  notImplemented("getStorageNodes")

method handleNodeData*(ctx: EthWireBase, peer: Peer, data: openArray[Blob]) {.base, gcsafe.} =
  notImplemented("handleNodeData")
