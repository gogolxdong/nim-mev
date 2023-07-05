{.push raises: [].}

import
  std/[options, times],
  chronicles,
  eth/trie/trie_defs,
  ./chain_config,
  ./hardforks,
  ./evmforks,
  ./genesis,
  ../utils/[utils, ec_recover],
  ../db/[db_chain, storage_types],
  ../core/[clique, casper]

export
  chain_config,
  db_chain,
  options,
  evmforks,
  hardforks,
  genesis,
  utils

type
  SyncProgress = object
    start  : BlockNumber
    current: BlockNumber
    highest: BlockNumber

  SyncReqNewHeadCB* = proc(header: BlockHeader) {.gcsafe, raises: [].}

  CommonRef* = ref object
    db: ChainDBRef

    pruneTrie: bool

    config: ChainConfig

    genesisHash: KeccakHash
    genesisHeader: BlockHeader

    forkTransitionTable: ForkTransitionTable

    forkIds: array[HardFork, ForkID]
    networkId: NetworkId

    syncProgress: SyncProgress

    currentFork: HardFork

    consensusType: ConsensusType

    syncReqNewHead: SyncReqNewHeadCB
    syncReqRelaxV2: bool
    startOfHistory: Hash256

    poa: Clique
    pos: CasperRef


proc hardForkTransition*(
  com: CommonRef, forkDeterminer: ForkDeterminationInfo)
  {.gcsafe, raises: [].}

func cliquePeriod*(com: CommonRef): int

func cliqueEpoch*(com: CommonRef): int


proc consensusTransition(com: CommonRef, fork: HardFork) =
  if fork >= MergeFork:
    com.consensusType = ConsensusType.POS
  else:
    com.consensusType = com.config.consensusType

proc setForkId(com: CommonRef, blockZero: BlockHeader) =
  com.genesisHash = blockZero.blockHash
  let genesisCRC = crc32(0, com.genesisHash.data)
  com.forkIds = calculateForkIds(com.config, genesisCRC)

proc daoCheck(conf: ChainConfig) =
  if not conf.daoForkSupport or conf.daoForkBlock.isNone:
    conf.daoForkBlock = conf.homesteadBlock

  if conf.daoForkSupport and conf.daoForkBlock.isNone:
    conf.daoForkBlock = conf.homesteadBlock

proc init(com      : CommonRef,
          db       : TrieDatabaseRef,
          pruneTrie: bool,
          networkId: NetworkId,
          config   : ChainConfig,
          genesis  : Genesis) {.gcsafe, raises: [CatchableError].} =

  config.daoCheck()

  com.db          = ChainDBRef.new(db)
  com.pruneTrie   = pruneTrie
  com.config      = config
  com.forkTransitionTable = config.toForkTransitionTable()
  com.networkId   = networkId
  com.syncProgress= SyncProgress()

  const TimeZero = fromUnix(0)
  com.hardForkTransition(ForkDeterminationInfo(blockNumber: 0.toBlockNumber, td: some(0.u256), time: some(TimeZero)))

  if genesis.isNil.not:
    com.genesisHeader = toGenesisHeader(genesis, com.currentFork, com.db.db)
    com.setForkId(com.genesisHeader)

  com.poa = newClique(com.db, com.cliquePeriod, com.cliqueEpoch)
  com.pos = CasperRef.new

  com.startOfHistory = GENESIS_PARENT_HASH

proc getTd(com: CommonRef, blockHash: Hash256): Option[DifficultyInt] =
  var td: DifficultyInt
  if not com.db.getTd(blockHash, td):
    none[DifficultyInt]()
  else:
    some(td)

proc needTdForHardForkDetermination(com: CommonRef): bool =
  let t = com.forkTransitionTable.mergeForkTransitionThreshold
  t.blockNumber.isNone and t.ttd.isSome

proc getTdIfNecessary(com: CommonRef, blockHash: Hash256): Option[DifficultyInt] =
  if needTdForHardForkDetermination(com):
    getTd(com, blockHash)
  else:
    none[DifficultyInt]()

proc new*(_: type CommonRef,
          db: TrieDatabaseRef,
          pruneTrie: bool = true,
          networkId: NetworkId = MainNet,
          params = networkParams(BSC)): CommonRef
            {.gcsafe, raises: [CatchableError].} =
  new(result)
  result.init(db,pruneTrie,networkId,params.config,params.genesis)

proc new*(_: type CommonRef,
          db: TrieDatabaseRef,
          config: ChainConfig,
          pruneTrie: bool = true,
          networkId: NetworkId = MainNet): CommonRef
            {.gcsafe, raises: [CatchableError].} =

  new(result)
  result.init(db,pruneTrie,networkId,config,nil)

proc clone*(com: CommonRef, db: TrieDatabaseRef): CommonRef =
  CommonRef(
    db           : ChainDBRef.new(db),
    pruneTrie    : com.pruneTrie,
    config       : com.config,
    forkTransitionTable: com.forkTransitionTable,
    forkIds      : com.forkIds,
    genesisHash  : com.genesisHash,
    genesisHeader: com.genesisHeader,
    syncProgress : com.syncProgress,
    networkId    : com.networkId,
    currentFork  : com.currentFork,
    consensusType: com.consensusType,
    poa          : com.poa,
    pos          : com.pos
  )

proc clone*(com: CommonRef): CommonRef =
  com.clone(com.db.db)

func toHardFork*(com: CommonRef, forkDeterminer: ForkDeterminationInfo): HardFork =
  toHardFork(com.forkTransitionTable, forkDeterminer)

proc hardForkTransition(com: CommonRef, forkDeterminer: ForkDeterminationInfo) {.gcsafe, raises: [].} =
  let fork = com.toHardFork(forkDeterminer)
  com.currentFork = fork
  com.consensusTransition(fork)

proc hardForkTransition*(
    com: CommonRef,
    number: BlockNumber,
    td: Option[DifficultyInt],
    time: Option[EthTime])
    {.gcsafe, raises: [].} =
  com.hardForkTransition(ForkDeterminationInfo(
    blockNumber: number, time: time, td: td))

proc hardForkTransition*(
    com: CommonRef,
    parentHash: Hash256,
    number: BlockNumber,
    time: Option[EthTime])
    {.gcsafe, raises: [].} =
  com.hardForkTransition(number, getTdIfNecessary(com, parentHash), time)

proc hardForkTransition*(
    com: CommonRef, header: BlockHeader)
    {.gcsafe, raises: [].} =
  com.hardForkTransition(
    header.parentHash, header.blockNumber, some(header.timestamp))

func toEVMFork*(com: CommonRef, forkDeterminer: ForkDeterminationInfo): EVMFork =
  let fork = com.toHardFork(forkDeterminer)
  ToEVMFork[fork]

func toEVMFork*(com: CommonRef): EVMFork =
  ToEVMFork[com.currentFork]

func isLondon*(com: CommonRef, number: BlockNumber): bool =
  com.toHardFork(number.blockNumberToForkDeterminationInfo) >= London

func isLondon*(com: CommonRef, number: BlockNumber, timestamp: EthTime): bool =
  com.toHardFork(forkDeterminationInfo(number, timestamp)) >= London

func forkGTE*(com: CommonRef, fork: HardFork): bool =
  com.currentFork >= fork

proc minerAddress*(com: CommonRef; header: BlockHeader): EthAddress
    {.gcsafe, raises: [CatchableError].} =
  if com.consensusType != ConsensusType.POA:
    return header.coinbase

  let account = header.ecRecover
  if account.isErr:
    let msg = "Could not recover account address: " & $account.error
    raise newException(ValidationError, msg)

  account.value

func forkId*(com: CommonRef, forkDeterminer: ForkDeterminationInfo): ForkID {.gcsafe.} =
  let fork = com.toHardFork(forkDeterminer)
  com.forkIds[fork]

func isEIP155*(com: CommonRef, number: BlockNumber): bool =
  com.config.eip155Block.isSome and number >= com.config.eip155Block.get

proc isBlockAfterTtd*(com: CommonRef, header: BlockHeader): bool
                      {.gcsafe, raises: [CatchableError].} =
  if com.config.terminalTotalDifficulty.isNone:
    return false

  let
    ttd = com.config.terminalTotalDifficulty.get()
    ptd = com.db.getScore(header.parentHash)
    td  = ptd + header.difficulty
  ptd >= ttd and td >= ttd

func isShanghaiOrLater*(com: CommonRef, t: EthTime): bool =
  com.config.shanghaiTime.isSome and t >= com.config.shanghaiTime.get

func isCancunOrLater*(com: CommonRef, t: EthTime): bool =
  com.config.cancunTime.isSome and t >= com.config.cancunTime.get

proc consensus*(com: CommonRef, header: BlockHeader): ConsensusType
                {.gcsafe, raises: [CatchableError].} =
  if com.isBlockAfterTtd(header):
    return ConsensusType.POS

  return com.config.consensusType

proc initializeEmptyDb*(com: CommonRef)
    {.gcsafe, raises: [CatchableError].} =
  let trieDB = com.db.db
  if canonicalHeadHashKey().toOpenArray notin trieDB:
    info "Writing genesis to DB"
    doAssert(com.genesisHeader.blockNumber.isZero,
      "can't commit genesis block with number > 0")
    discard com.db.persistHeaderToDb(com.genesisHeader, com.consensusType == ConsensusType.POS)
    doAssert(canonicalHeadHashKey().toOpenArray in trieDB)

proc syncReqNewHead*(com: CommonRef; header: BlockHeader)
    {.gcsafe, raises: [].} =
  ## Used by RPC to update the beacon head for snap sync
  if not com.syncReqNewHead.isNil:
    com.syncReqNewHead(header)

# ------------------------------------------------------------------------------
# Getters
# ------------------------------------------------------------------------------

func startOfHistory*(com: CommonRef): Hash256 =
  ## Getter
  com.startOfHistory

func poa*(com: CommonRef): Clique =
  ## Getter
  com.poa

func pos*(com: CommonRef): CasperRef =
  ## Getter
  com.pos

func db*(com: CommonRef): ChainDBRef =
  com.db

func consensus*(com: CommonRef): ConsensusType =
  com.consensusType

func eip150Block*(com: CommonRef): Option[BlockNumber] =
  com.config.eip150Block

func eip150Hash*(com: CommonRef): Hash256 =
  com.config.eip150Hash

func daoForkBlock*(com: CommonRef): Option[BlockNumber] =
  com.config.daoForkBlock

func daoForkSupport*(com: CommonRef): bool =
  com.config.daoForkSupport

func ttd*(com: CommonRef): Option[DifficultyInt] =
  com.config.terminalTotalDifficulty

func cliquePeriod*(com: CommonRef): int =
  if com.config.clique.period.isSome:
    return com.config.clique.period.get()

func cliqueEpoch*(com: CommonRef): int =
  if com.config.clique.epoch.isSome:
    return com.config.clique.epoch.get()

func pruneTrie*(com: CommonRef): bool =
  com.pruneTrie


func chainId*(com: CommonRef): ChainId =
  com.config.chainId

func networkId*(com: CommonRef): NetworkId =
  com.networkId

func blockReward*(com: CommonRef): UInt256 =
  BlockRewards[com.currentFork]

func genesisHash*(com: CommonRef): Hash256 =
  ## Getter
  com.genesisHash

func genesisHeader*(com: CommonRef): BlockHeader =
  ## Getter
  com.genesisHeader

func syncStart*(com: CommonRef): BlockNumber =
  com.syncProgress.start

func syncCurrent*(com: CommonRef): BlockNumber =
  com.syncProgress.current

func syncHighest*(com: CommonRef): BlockNumber =
  com.syncProgress.highest

func syncReqRelaxV2*(com: CommonRef): bool =
  com.syncReqRelaxV2

# ------------------------------------------------------------------------------
# Setters
# ------------------------------------------------------------------------------

proc `syncStart=`*(com: CommonRef, number: BlockNumber) =
  com.syncProgress.start = number

proc `syncCurrent=`*(com: CommonRef, number: BlockNumber) =
  com.syncProgress.current = number

proc `syncHighest=`*(com: CommonRef, number: BlockNumber) =
  com.syncProgress.highest = number

proc `startOfHistory=`*(com: CommonRef, val: Hash256) =
  ## Setter
  com.startOfHistory = val

proc setTTD*(com: CommonRef, ttd: Option[DifficultyInt]) =
  ## useful for testing
  com.config.terminalTotalDifficulty = ttd
  # rebuild the MergeFork piece of the forkTransitionTable
  com.forkTransitionTable.mergeForkTransitionThreshold = com.config.mergeForkTransitionThreshold

proc setFork*(com: CommonRef, fork: HardFork): Hardfork =
  ## useful for testing
  result = com.currentFork
  com.currentFork = fork
  com.consensusTransition(fork)

proc `syncReqNewHead=`*(com: CommonRef; cb: SyncReqNewHeadCB) =
  ## Activate or reset a call back handler for syncing. When resetting (by
  ## passing `cb` as `nil`), the `syncReqRelaxV2` value is also reset.
  com.syncReqNewHead = cb
  if cb.isNil:
    com.syncReqRelaxV2 = false

proc `syncReqRelaxV2=`*(com: CommonRef; val: bool) =
  ## Allow processing of certain RPC/V2 messages type while syncing (i.e.
  ## `syncReqNewHead` is set.) although `shanghaiTime` is unavailable
  ## or has not reached, yet.
  ##
  ## This setter is effective only while `syncReqNewHead` is activated.
  if not com.syncReqNewHead.isNil:
    com.syncReqRelaxV2 = val

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
