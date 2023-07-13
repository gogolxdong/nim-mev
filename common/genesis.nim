import
  chronicles,
  std/tables,
  eth/[common, rlp, eip1559],
  eth/trie/[db, trie_defs],
  ../db/state_db,
  ../constants,
  ./chain_config

{.push raises: [].}

proc newStateDB*(db: TrieDatabaseRef;pruneTrie: bool;): AccountStateDB {.gcsafe, raises: [].}=
  newAccountStateDB(db, emptyRlpHash, pruneTrie)

# {ParentHash:0x0000000000000000000000000000000000000000000000000000000000000000
#  UncleHash:0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347 
#  Coinbase:0xffffFFFfFFffffffffffffffFfFFFfffFFFfFFfE 
#  Root:0x919fcc7ad870b53db0aa76eb588da06bacb6d230195100699fc928511003b422 
#  TxHash:0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421 
#  ReceiptHash:0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421 
#  Bloom:[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 
#  Difficulty:+1 
#  Number:+0 
#  GasLimit:40000000 
#  GasUsed:0 
#  Time:1587390414 
#  Extra:[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 42 124 221 149 155 254 141 148 135 178 164 59 51 86 82 149 166 152 247 226 100 136 170 77 25 85 238 51 64 63 140 203 29 77 229 251 151 199 173 226 158 249 244 54 12 96 108 122 180 219 38 176 22 0 125 58 208 171 134 160 238 1 195 177 40 58 160 103 197 142 171 71 9 248 94 153 212 109 229 254 104 91 29 237 128 19 120 93 102 35 204 24 210 20 50 11 107 182 71 89 120 243 173 252 113 156 153 103 76 7 33 102 112 133 137 3 62 45 154 254 194 190 78 194 2 83 184 100 33 97 188 63 68 79 83 103 156 31 61 71 47 123 232 54 28 128 164 193 231 233 170 240 1 208 135 127 28 253 226 24 206 47 215 84 78 11 44 201 70 146 212 167 4 222 190 247 188 182 19 40 184 247 22 100 150 153 106 125 162 28 241 241 176 77 155 62 38 163 208 119 45 76 64 123 190 73 67 142 216 89 254 150 91 20 13 207 26 171 113 169 107 186 215 207 52 181 250 81 29 142 150 61 187 162 136 177 150 14 117 214 68 48 179 35 2 148 209 44 106 178 170 197 194 205 104 232 11 22 181 129 234 10 110 60 81 27 189 16 244 81 158 206 55 220 36 136 126 17 181 93 122 226 245 185 227 134 205 27 80 164 85 6 150 217 87 203 73 0 240 58 130 1 39 8 218 252 158 27 136 15 208 131 179 33 130 184 105 190 142 9 34 184 31 142 23 95 253 229 77 121 127 225 30 176 63 158 59 247 95 29 104 191 11 139 111 180 227 23 160 249 214 240 62 175 140 230 103 91 198 13 140 77 144 130 156 232 247 45 1 99 193 213 207 52 138 134 45 85 6 48 53 231 160 37 244 218 150 141 231 228 215 228 0 65 151 145 127 64 112 241 214 202 160 43 190 186 235 181 215 229 129 228 182 101 89 230 53 248 5 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 
#  MixDigest:0x0000000000000000000000000000000000000000000000000000000000000000 
#  Nonce:[0 0 0 0 0 0 0 0] 
#  BaseFee:<nil>}  

# parentHash: 0000000000000000000000000000000000000000000000000000000000000000, 
# ommersHash: 1DCC4DE8DEC75D7AAB85B567B6CCD41AD312451B948A7413F0A142FD40D49347, 
# coinbase: fffffffffffffffffffffffffffffffffffffffe, 
# stateRoot: 919FCC7AD870B53DB0AA76EB588DA06BACB6D230195100699FC928511003B422, 
# txRoot: 56E81F171BCC55A6FF8345E692C0F86E5B48E01B996CADC001622FB5E363B421, 
# receiptRoot: 56E81F171BCC55A6FF8345E692C0F86E5B48E01B996CADC001622FB5E363B421, 
# bloom: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
# difficulty: 1, 
# blockNumber: 0, 
# gasLimit: 40000000, 
# gasUsed: 0, 
# timestamp: 2020-04-20T21:46:54+08:00, 
# extraData:[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 42 124 221 149 155 254 141 148 135 178 164 59 51 86 82 149 166 152 247 226 100 136 170 77 25 85 238 51 64 63 140 203 29 77 229 251 151 199 173 226 158 249 244 54 12 96 108 122 180 219 38 176 22 0 125 58 208 171 134 160 238 1 195 177 40 58 160 103 197 142 171 71 9 248 94 153 212 109 229 254 104 91 29 237 128 19 120 93 102 35 204 24 210 20 50 11 107 182 71 89 120 243 173 252 113 156 153 103 76 7 33 102 112 133 137 3 62 45 154 254 194 190 78 194 2 83 184 100 33 97 188 63 68 79 83 103 156 31 61 71 47 123 232 54 28 128 164 193 231 233 170 240 1 208 135 127 28 253 226 24 206 47 215 84 78 11 44 201 70 146 212 167 4 222 190 247 188 182 19 40 184 247 22 100 150 153 106 125 162 28 241 241 176 77 155 62 38 163 208 119 45 76 64 123 190 73 67 142 216 89 254 150 91 20 13 207 26 171 113 169 107 186 215 207 52 181 250 81 29 142 150 61 187 162 136 177 150 14 117 214 68 48 179 35 2 148 209 44 106 178 170 197 194 205 104 232 11 22 181 129 234 10 110 60 81 27 189 16 244 81 158 206 55 220 36 136 126 17 181 93 122 226 245 185 227 134 205 27 80 164 85 6 150 217 87 203 73 0 240 58 130 1 39 8 218 252 158 27 136 15 208 131 179 33 130 184 105 190 142 9 34 184 31 142 23 95 253 229 77 121 127 225 30 176 63 158 59 247 95 29 104 191 11 139 111 180 227 23 160 249 214 240 62 175 140 230 103 91 198 13 140 77 144 130 156 232 247 45 1 99 193 213 207 52 138 134 45 85 6 48 53 231 160 37 244 218 150 141 231 228 215 228 0 65 151 145 127 64 112 241 214 202 160 43 190 186 235 181 215 229 129 228 182 101 89 230 53 248 5 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0], 
# mixDigest: 0000000000000000000000000000000000000000000000000000000000000000, 
# nonce: [0, 0, 0, 0, 0, 0, 0, 0], 
# fee: none(UInt256)
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
    ommersHash: EMPTY_UNCLE_HASH,
    coinbase: g.coinbase,
    stateRoot: sdb.rootHash,
    txRoot: EMPTY_ROOT_HASH,
    receiptRoot: EMPTY_ROOT_HASH,
    timestamp: g.timestamp,
    extraData: g.extraData,
    gasLimit: g.gasLimit,
    difficulty: g.difficulty,
    mixDigest: g.mixHash,
    nonce: g.nonce,
  )
  info "toGenesisHeader", header=result, genesis=g.repr

  if g.baseFeePerGas.isSome:
    result.baseFee = g.baseFeePerGas.get()
  elif fork >= London:
    result.baseFee = EIP1559_INITIAL_BASE_FEE.u256

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


