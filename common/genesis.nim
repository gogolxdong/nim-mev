import
  std/tables,
  eth/[common, rlp, eip1559],
  ../constants,
  ./chain_config

{.push raises: [].}

proc toGenesisHeader*(
    g: Genesis;
    fork: HardFork;
      ): BlockHeader
      {.gcsafe, raises: [RlpError].} =

  result = BlockHeader(
    nonce: g.nonce,
    timestamp: g.timestamp,
    extraData: g.extraData,
    gasLimit: g.gasLimit,
    difficulty: g.difficulty,
    mixDigest: g.mixHash,
    coinbase: g.coinbase,
    parentHash: GENESIS_PARENT_HASH,
    txRoot: EMPTY_ROOT_HASH,
    receiptRoot: EMPTY_ROOT_HASH,
    ommersHash: EMPTY_UNCLE_HASH
  )

  if g.baseFeePerGas.isSome:
    result.baseFee = g.baseFeePerGas.get()
  elif fork >= London:
    result.baseFee = EIP1559_INITIAL_BASE_FEE.u256

  if g.gasLimit.isZero:
    result.gasLimit = GENESIS_GAS_LIMIT

  if g.difficulty.isZero and fork <= London:
    result.difficulty = GENESIS_DIFFICULTY


proc toGenesisHeader*(
    params: NetworkParams;
      ): BlockHeader
      {.raises: [RlpError].} =
  let map  = toForkTransitionTable(params.config)
  let fork = map.toHardFork(forkDeterminationInfo(0.toBlockNumber, params.genesis.timestamp))
  toGenesisHeader(params.genesis, fork)

