import
  std/tables,
  eth/[common, rlp, eip1559],
  eth/trie/[db, trie_defs],
  ../db/state_db,
  ../constants,
  ./chain_config

{.push raises: [].}

proc newStateDB*(db: TrieDatabaseRef;pruneTrie: bool;): AccountStateDB {.gcsafe, raises: [].}=
  newAccountStateDB(db, emptyRlpHash, pruneTrie)
  
proc toGenesisHeader*(g: Genesis;sdb: AccountStateDB;fork: HardFork;): BlockHeader {.gcsafe, raises: [RlpError].} =
  sdb.db.put(emptyRlpHash.data, emptyRlp)

  for address, account in g.alloc:
    sdb.setAccount(address, newAccount(account.nonce, account.balance))
    sdb.setCode(address, account.code)
    if sdb.pruneTrie and 0 < account.storage.len:
      sdb.db.put(emptyRlpHash.data, emptyRlp) 

    for k, v in account.storage:
      sdb.setStorage(address, k, v)

  result = BlockHeader(
    parentHash: GENESIS_PARENT_HASH,
    ommersHash: Hash256.fromHex"0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
    coinbase: g.coinbase,
    stateRoot: Hash256.fromHex"0x919fcc7ad870b53db0aa76eb588da06bacb6d230195100699fc928511003b422",
    txRoot: Hash256.fromHex"0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
    receiptRoot: Hash256.fromHex"0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
    difficulty: g.difficulty,
    blockNumber: 0.u256,
    gasLimit: g.gasLimit,
    gasUsed: g.gasUsed,
    timestamp: g.timestamp,
    extraData: g.extraData,
    mixDigest: g.mixHash,
    nonce: g.nonce,
  )

  # if g.baseFeePerGas.isSome:
  #   result.baseFee = g.baseFeePerGas.get()
  # elif fork >= London:
  #   result.baseFee = EIP1559_INITIAL_BASE_FEE.u256

  if g.gasLimit == 0:
    result.gasLimit = GENESIS_GAS_LIMIT

  if g.difficulty.isZero and fork <= London:
    result.difficulty = GENESIS_DIFFICULTY

  # if fork >= Shanghai:
  #   result.withdrawalsRoot = some(EMPTY_ROOT_HASH)

proc toGenesisHeader*(genesis: Genesis; fork: HardFork; db = TrieDatabaseRef(nil);): BlockHeader {.gcsafe, raises: [RlpError].} =
  let
    db  = if db.isNil: newMemoryDB() else: db
    sdb = newStateDB(db, pruneTrie = true)
  toGenesisHeader(genesis, sdb, fork)

proc toGenesisHeader*(params: NetworkParams;db = TrieDatabaseRef(nil);): BlockHeader {.raises: [RlpError].} =
  let map  = toForkTransitionTable(params.config)
  let fork = map.toHardFork(forkDeterminationInfo(0.toBlockNumber, params.genesis.timestamp))
  toGenesisHeader(params.genesis, fork, db)


