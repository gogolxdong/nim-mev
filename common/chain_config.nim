# Nimbus
# Copyright (c) 2021 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE))
#  * MIT license ([LICENSE-MIT](LICENSE-MIT))
# at your option.
# This file may not be copied, modified, or distributed except according to
# those terms.

{.push raises: [].}

import
  std/[tables, strutils, options, times, macros],
  eth/[common, rlp, p2p], stint, stew/[byteutils],
  json_serialization, chronicles,
  json_serialization/std/options as jsoptions,
  json_serialization/std/tables as jstable,
  json_serialization/lexer,
  ./[hardforks]

export
  hardforks

type
  Genesis* = ref object
    nonce*      : BlockNonce
    timestamp*  : EthTime
    extraData*  : seq[byte]
    gasLimit*   : GasInt
    difficulty* : DifficultyInt
    mixHash*    : Hash256
    coinbase*   : EthAddress
    alloc*      : GenesisAlloc
    number*     : BlockNumber
    gasUser*    : GasInt
    parentHash* : Hash256
    baseFeePerGas*: Option[UInt256]

  GenesisAlloc* = Table[EthAddress, GenesisAccount]
  GenesisAccount* = object
    code*   : seq[byte]
    storage*: Table[UInt256, UInt256]
    balance*: UInt256
    nonce*  : AccountNonce

  NetworkParams* = object
    config* : ChainConfig
    genesis*: Genesis

  AddressBalance = object
    address {.rlpCustomSerialization.}: EthAddress
    account {.rlpCustomSerialization.}: GenesisAccount

  GenesisFile* = object
    config      : ChainConfig
    nonce*      : BlockNonce
    timestamp*  : EthTime
    extraData*  : seq[byte]
    gasLimit*   : GasInt
    difficulty* : DifficultyInt
    mixHash*    : Hash256
    coinbase*   : EthAddress
    alloc*      : GenesisAlloc
    number*     : BlockNumber
    gasUser*    : GasInt
    parentHash* : Hash256
    baseFeePerGas*: Option[UInt256]

const
  CustomNet*  = 0.NetworkId
  MainNet*    = 1.NetworkId
  RopstenNet* = 3.NetworkId
  RinkebyNet* = 4.NetworkId
  GoerliNet*  = 5.NetworkId
  KovanNet*   = 42.NetworkId
  BSC*   = 56.NetworkId
  SepoliaNet* = 11155111.NetworkId

# ------------------------------------------------------------------------------
# Private helper functions
# ------------------------------------------------------------------------------

proc read(rlp: var Rlp, x: var AddressBalance, _: type EthAddress): EthAddress
    {.gcsafe, raises: [RlpError].} =
  let val = rlp.read(UInt256).toByteArrayBE()
  result[0 .. ^1] = val.toOpenArray(12, val.high)

proc read(rlp: var Rlp, x: var AddressBalance, _: type GenesisAccount): GenesisAccount
    {.gcsafe, raises: [RlpError].} =
  GenesisAccount(balance: rlp.read(UInt256))

func decodePrealloc*(data: seq[byte]): GenesisAlloc
    {.gcsafe, raises: [RlpError].} =
  for tup in rlp.decode(data, seq[AddressBalance]):
    result[tup.address] = tup.account

# borrowed from `lexer.hexCharValue()` :)
proc fromHex(c: char): int =
  case c
  of '0'..'9': ord(c) - ord('0')
  of 'a'..'f': ord(c) - ord('a') + 10
  of 'A'..'F': ord(c) - ord('A') + 10
  else: -1

proc readValue(reader: var JsonReader, value: var UInt256)
    {.gcsafe, raises: [SerializationError, IOError].} =
  ## Mixin for `Json.loadFile()`. Note that this driver applies the same
  ## to `BlockNumber` fields as well as generic `UInt265` fields like the
  ## account `balance`.
  var (accu, ok) = (0.u256, true)
  if reader.lexer.lazyTok == tkNumeric:
    try:
      reader.lexer.customIntValueIt:
        accu = accu * 10 + it.u256
      ok = reader.lexer.lazyTok == tkExInt # non-negative wanted
    except CatchableError:
      ok = false
  elif reader.lexer.lazyTok == tkQuoted:
    try:
      var (sLen, base) = (0, 10)
      reader.lexer.customTextValueIt:
        if ok:
          var num = it.fromHex
          if base <= num:
            ok = false # cannot be larger than base
          elif sLen < 2:
            if 0 <= num:
              accu = accu * base.u256 + num.u256
            elif sLen == 1 and it in {'x', 'X'}:
              base = 16 # handle "0x" prefix
            else:
              ok = false
            sLen.inc
          elif num < 0:
            ok = false # not a hex digit
          elif base == 10:
            accu = accu * 10 + num.u256
          else:
            accu = accu * 16 + num.u256
    except CatchableError:
      reader.raiseUnexpectedValue("numeric string parse error")
  else:
    reader.raiseUnexpectedValue("expect int or hex/int string")
  if not ok:
    reader.raiseUnexpectedValue("Uint256 parse error")
  value = accu
  reader.lexer.next()

proc readValue(reader: var JsonReader, value: var ChainId)
    {.gcsafe, raises: [SerializationError, IOError].} =
  value = reader.readValue(int).ChainId

proc readValue(reader: var JsonReader, value: var Hash256)
    {.gcsafe, raises: [SerializationError, IOError].} =
  value = Hash256.fromHex(reader.readValue(string))

proc readValue(reader: var JsonReader, value: var BlockNonce)
    {.gcsafe, raises: [SerializationError, IOError].} =
  try:
    value = fromHex[uint64](reader.readValue(string)).toBlockNonce
  except ValueError as ex:
    reader.raiseUnexpectedValue(ex.msg)

proc readValue(reader: var JsonReader, value: var EthTime)
    {.gcsafe, raises: [SerializationError, IOError].} =
  try:
    value = fromHex[int64](reader.readValue(string)).fromUnix
  except ValueError as ex:
    reader.raiseUnexpectedValue(ex.msg)

proc readValue(reader: var JsonReader, value: var seq[byte])
    {.gcsafe, raises: [SerializationError, IOError].} =
  try:
    value = hexToSeqByte(reader.readValue(string))
  except ValueError as ex:
    reader.raiseUnexpectedValue(ex.msg)

proc readValue(reader: var JsonReader, value: var GasInt)
    {.gcsafe, raises: [SerializationError, IOError].} =
  try:
    value = fromHex[GasInt](reader.readValue(string))
  except ValueError as ex:
    reader.raiseUnexpectedValue(ex.msg)

proc readValue(reader: var JsonReader, value: var EthAddress)
    {.gcsafe, raises: [SerializationError, IOError].} =
  try:
    value = parseAddress(reader.readValue(string))
  except ValueError as ex:
    reader.raiseUnexpectedValue(ex.msg)

proc readValue(reader: var JsonReader, value: var AccountNonce)
    {.gcsafe, raises: [SerializationError, IOError].} =
  try:
    value = fromHex[uint64](reader.readValue(string))
  except ValueError as ex:
    reader.raiseUnexpectedValue(ex.msg)

template to(a: string, b: type EthAddress): EthAddress =
  # json_serialization decode table stuff
  parseAddress(a)

template to(a: string, b: type UInt256): UInt256 =
  # json_serialization decode table stuff
  UInt256.fromHex(a)

macro fillArrayOfBlockNumberBasedForkOptionals(conf, tmp: typed): untyped =
  result = newStmtList()
  for i, x in forkBlockField:
    let fieldIdent = newIdentNode(x)
    result.add quote do:
      `tmp`[`i`] = BlockNumberBasedForkOptional(
        number  : `conf`.`fieldIdent`,
        name    : `x`)

macro fillArrayOfTimeBasedForkOptionals(conf, tmp: typed): untyped =
  result = newStmtList()
  for i, x in forkTimeField:
    let fieldIdent = newIdentNode(x)
    result.add quote do:
      `tmp`[`i`] = TimeBasedForkOptional(
        time    : `conf`.`fieldIdent`,
        name    : `x`)

# ------------------------------------------------------------------------------
# Public functions
# ------------------------------------------------------------------------------

proc toHardFork*(map: ForkTransitionTable, forkDeterminer: ForkDeterminationInfo): HardFork =
  for fork in countdown(HardFork.high, HardFork.low):
    if isGTETransitionThreshold(map, forkDeterminer, fork):
      return fork

  # should always have a match
  doAssert(false, "unreachable code")

func forkDeterminationInfoForHeader*(header: BlockHeader): ForkDeterminationInfo =
  # FIXME-Adam-mightAlsoNeedTTD?
  forkDeterminationInfo(header.blockNumber, header.timestamp)

proc validateChainConfig*(conf: ChainConfig): bool =
  result = true

  # FIXME: factor this to remove the duplication between the
  # block-based ones and the time-based ones.

  var blockNumberBasedForkOptionals: array[forkBlockField.len, BlockNumberBasedForkOptional]
  fillArrayOfBlockNumberBasedForkOptionals(conf, blockNumberBasedForkOptionals)

  var timeBasedForkOptionals: array[forkTimeField.len, TimeBasedForkOptional]
  fillArrayOfTimeBasedForkOptionals(conf, timeBasedForkOptionals)

  var lastBlockNumberBasedFork = blockNumberBasedForkOptionals[0]
  for i in 1..<blockNumberBasedForkOptionals.len:
    let cur = blockNumberBasedForkOptionals[i]

    if lastBlockNumberBasedFork.number.isSome and cur.number.isSome:
      if lastBlockNumberBasedFork.number.get > cur.number.get:
        error "Unsupported fork ordering",
          lastFork=lastBlockNumberBasedFork.name,
          lastNumber=lastBlockNumberBasedFork.number,
          curFork=cur.name,
          curNumber=cur.number
        return false

    # If it was optional and not set, then ignore it
    if cur.number.isSome:
      lastBlockNumberBasedFork = cur

  # TODO: check to make sure the timestamps are all past the
  # block numbers?

  var lastTimeBasedFork = timeBasedForkOptionals[0]
  for i in 1..<timeBasedForkOptionals.len:
    let cur = timeBasedForkOptionals[i]

    if lastTimeBasedFork.time.isSome and cur.time.isSome:
      if lastTimeBasedFork.time.get > cur.time.get:
        error "Unsupported fork ordering",
          lastFork=lastTimeBasedFork.name,
          lastTime=lastTimeBasedFork.time,
          curFork=cur.name,
          curTime=cur.time
        return false

    # If it was optional and not set, then ignore it
    if cur.time.isSome:
      lastTimeBasedFork = cur

  if conf.clique.period.isSome or
     conf.clique.epoch.isSome:
    conf.consensusType = ConsensusType.POA

proc validateNetworkParams*(params: var NetworkParams): bool =
  if params.genesis.isNil:
    warn "Loaded custom network contains no 'genesis' data"

  if params.config.isNil:
    warn "Loaded custom network contains no 'config' data"
    params.config = ChainConfig()

  validateChainConfig(params.config)

proc loadNetworkParams*(fileName: string, params: var NetworkParams):
    bool =
  try:
    params = Json.loadFile(fileName, NetworkParams, allowUnknownFields = true)
  except IOError as e:
    error "Network params I/O error", fileName, msg=e.msg
    return false
  except JsonReaderError as e:
    error "Invalid network params file format", fileName, msg=e.formatMsg("")
    return false
  except CatchableError as e:
    error "Error loading network params file",
      fileName, exception = e.name, msg = e.msg
    return false

  validateNetworkParams(params)

proc decodeNetworkParams*(jsonString: string, params: var NetworkParams): bool =
  try:
    params = Json.decode(jsonString, NetworkParams, allowUnknownFields = true)
  except JsonReaderError as e:
    error "Invalid network params format", msg=e.formatMsg("")
    return false
  except CatchableError:
    var msg = getCurrentExceptionMsg()
    error "Error decoding network params", msg
    return false

  validateNetworkParams(params)

proc parseGenesisAlloc*(data: string, ga: var GenesisAlloc): bool
    {.gcsafe, raises: [CatchableError].} =
  try:
    ga = Json.decode(data, GenesisAlloc, allowUnknownFields = true)
  except JsonReaderError as e:
    error "Invalid genesis config file format", msg=e.formatMsg("")
    return false

  return true

proc parseGenesis*(data: string): Genesis
     {.gcsafe, raises: [CatchableError].} =
  try:
    result = Json.decode(data, Genesis, allowUnknownFields = true)
  except JsonReaderError as e:
    error "Invalid genesis config file format", msg=e.formatMsg("")
    return nil

proc chainConfigForNetwork*(id: NetworkId): ChainConfig =
  result = case id
  of BSC:
    const mainNetTTD = parse("58750000000000000000000",UInt256)
    ChainConfig(
      consensusType:       ConsensusType.POA,
      chainId:             MainNet.ChainId,
      homesteadBlock:      some(0.toBlockNumber),  # 2016-03-14 18:49:53 UTC
      daoForkBlock:        some(0.toBlockNumber),  # 2016-07-20 13:20:40 UTC
      daoForkSupport:      true,
      eip150Block:         some(0.toBlockNumber),  # 2016-10-18 13:19:31 UTC
      eip150Hash:          toDigest("0000000000000000000000000000000000000000000000000000000000000000"),
      eip155Block:         some(0.toBlockNumber),  # Same as EIP-158
      eip158Block:         some(0.toBlockNumber),  # 2016-11-22 16:15:44 UTC
      byzantiumBlock:      some(0.toBlockNumber),  # 2017-10-16 05:22:11 UTC
      constantinopleBlock: some(0.toBlockNumber),  # Skipped on Mainnet
      petersburgBlock:     some(0.toBlockNumber),  # 2019-02-28 19:52:04 UTC
      istanbulBlock:       some(0.toBlockNumber),  # 2019-12-08 00:25:09 UTC
      muirGlacierBlock:    some(0.toBlockNumber),  # 2020-01-02 08:30:49 UTC
      berlinBlock:         some(0.toBlockNumber), # 2021-04-15 10:07:03 UTC
      londonBlock:         some(0.toBlockNumber), # 2021-08-05 12:33:42 UTC
      arrowGlacierBlock:   some(0.toBlockNumber), # 2021-12-09 19:55:23 UTC
      grayGlacierBlock:    some(0.toBlockNumber), # 2022-06-30 10:54:04 UTC
      terminalTotalDifficulty: some(mainNetTTD),
      shanghaiTime:        some(0x5e9da7ce.fromUnix)
    )
  else:
    ChainConfig()

proc genesisBlockForNetwork*(id: NetworkId): Genesis {.gcsafe, raises: [ValueError, RlpError].} =
  result = case id
  of BSC:
    Genesis(
      nonce: 1.toBlockNonce,
      extraData: hexToSeqByte("0x00000000000000000000000000000000000000000000000000000000000000002a7cdd959bfe8d9487b2a43b33565295a698f7e26488aa4d1955ee33403f8ccb1d4de5fb97c7ade29ef9f4360c606c7ab4db26b016007d3ad0ab86a0ee01c3b1283aa067c58eab4709f85e99d46de5fe685b1ded8013785d6623cc18d214320b6bb6475978f3adfc719c99674c072166708589033e2d9afec2be4ec20253b8642161bc3f444f53679c1f3d472f7be8361c80a4c1e7e9aaf001d0877f1cfde218ce2fd7544e0b2cc94692d4a704debef7bcb61328b8f7166496996a7da21cf1f1b04d9b3e26a3d0772d4c407bbe49438ed859fe965b140dcf1aab71a96bbad7cf34b5fa511d8e963dbba288b1960e75d64430b3230294d12c6ab2aac5c2cd68e80b16b581ea0a6e3c511bbd10f4519ece37dc24887e11b55d7ae2f5b9e386cd1b50a4550696d957cb4900f03a82012708dafc9e1b880fd083b32182b869be8e0922b81f8e175ffde54d797fe11eb03f9e3bf75f1d68bf0b8b6fb4e317a0f9d6f03eaf8ce6675bc60d8c4d90829ce8f72d0163c1d5cf348a862d55063035e7a025f4da968de7e4d7e4004197917f4070f1d6caa02bbebaebb5d7e581e4b66559e635f805ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
      gasLimit: 0x2625a00,
      difficulty: 1.u256,
      alloc: GenesisAlloc.default
    )
  else:
    Genesis()

proc networkParams*(id: NetworkId): NetworkParams
    {.gcsafe, raises: [ValueError, RlpError].} =
  result.genesis = genesisBlockForNetwork(id)
  result.config  = chainConfigForNetwork(id)

proc `==`*(a, b: ChainId): bool =
  a.uint64 == b.uint64

proc `==`*(a, b: Genesis): bool =
  if a.isNil and b.isNil: return true
  if a.isNil and not b.isNil: return false
  if not a.isNil and b.isNil: return false
  a[] == b[]

proc `==`*(a, b: ChainConfig): bool =
  if a.isNil and b.isNil: return true
  if a.isNil and not b.isNil: return false
  if not a.isNil and b.isNil: return false
  a[] == b[]
