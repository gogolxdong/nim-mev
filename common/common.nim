# Nimbus
# Copyright (c) 2022-2023 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE))
#  * MIT license ([LICENSE-MIT](LICENSE-MIT))
# at your option.
# This file may not be copied, modified, or distributed except according to
# those terms.

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
  ../constants,
  ../errors

export
  chain_config,
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
    pruneTrie: bool
    config: ChainConfig
    genesisHash: KeccakHash
    genesisHeader: BlockHeader
    forkTransitionTable: ForkTransitionTable
    forkIds: array[HardFork, ForkID]
    networkId: NetworkId
    currentFork: HardFork
    startOfHistory: Hash256

proc hardForkTransition*(com: CommonRef, forkDeterminer: ForkDeterminationInfo)
  {.gcsafe, raises: [].}



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
          pruneTrie: bool,
          networkId: NetworkId,
          config   : ChainConfig,
          genesis  : Genesis) {.gcsafe, raises: [CatchableError].} =

  config.daoCheck()

  com.config      = config
  com.forkTransitionTable = config.toForkTransitionTable()
  com.networkId   = networkId

  const TimeZero = fromUnix(0)
  com.hardForkTransition(ForkDeterminationInfo(blockNumber: 0.toBlockNumber, td: some(0.u256), time: some(TimeZero)))

  if genesis.isNil.not:
    com.genesisHeader = toGenesisHeader(genesis,
      com.currentFork)
    com.setForkId(com.genesisHeader)
  com.startOfHistory = GENESIS_PARENT_HASH

proc needTdForHardForkDetermination(com: CommonRef): bool =
  let t = com.forkTransitionTable.mergeForkTransitionThreshold
  t.blockNumber.isNone and t.ttd.isSome

proc getTdIfNecessary(com: CommonRef, blockHash: Hash256): Option[DifficultyInt] =
    none[DifficultyInt]()

proc new*(_: type CommonRef,
          pruneTrie: bool = true,
          networkId: NetworkId = MainNet,
          params = networkParams(MainNet)): CommonRef
            {.gcsafe, raises: [CatchableError].} =

  new(result)
  result.init(pruneTrie,networkId,params.config,params.genesis)

proc new*(_: type CommonRef, config: ChainConfig, pruneTrie: bool = true, networkId: NetworkId = MainNet): CommonRef {.gcsafe, raises: [CatchableError].} =
  new(result)
  result.init(pruneTrie,networkId,config,nil)

proc clone*(com: CommonRef): CommonRef =
  CommonRef(
    pruneTrie    : com.pruneTrie,
    config       : com.config,
    forkTransitionTable: com.forkTransitionTable,
    forkIds      : com.forkIds,
    genesisHash  : com.genesisHash,
    genesisHeader: com.genesisHeader,
    networkId    : com.networkId,
    currentFork  : com.currentFork,
  )


func toHardFork*(
    com: CommonRef, forkDeterminer: ForkDeterminationInfo): HardFork =
  toHardFork(com.forkTransitionTable, forkDeterminer)

proc hardForkTransition(
    com: CommonRef, forkDeterminer: ForkDeterminationInfo)
    {.gcsafe, raises: [].} =
  let fork = com.toHardFork(forkDeterminer)
  com.currentFork = fork

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
  ## similar to toFork, but produce EVMFork
  let fork = com.toHardFork(forkDeterminer)
  ToEVMFork[fork]

func toEVMFork*(com: CommonRef): EVMFork =
  ToEVMFork[com.currentFork]

func isLondon*(com: CommonRef, number: BlockNumber): bool =
  # TODO: Fixme, use only London comparator
  com.toHardFork(number.blockNumberToForkDeterminationInfo) >= London

func isLondon*(com: CommonRef, number: BlockNumber, timestamp: EthTime): bool =
  # TODO: Fixme, use only London comparator
  com.toHardFork(forkDeterminationInfo(number, timestamp)) >= London

func forkGTE*(com: CommonRef, fork: HardFork): bool =
  com.currentFork >= fork

proc minerAddress*(com: CommonRef; header: BlockHeader): EthAddress
    {.gcsafe, raises: [CatchableError].} =
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

func isShanghaiOrLater*(com: CommonRef, t: EthTime): bool =
  com.config.shanghaiTime.isSome and t >= com.config.shanghaiTime.get

func startOfHistory*(com: CommonRef): Hash256 =
  com.startOfHistory

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
  com.genesisHash

func genesisHeader*(com: CommonRef): BlockHeader =
  com.genesisHeader

proc `startOfHistory=`*(com: CommonRef, val: Hash256) =
  com.startOfHistory = val

proc setFork*(com: CommonRef, fork: HardFork): Hardfork =
  result = com.currentFork
  com.currentFork = fork
