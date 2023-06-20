import
  std/[sequtils, sets, times, strutils],
  ../common,
  ".."/[errors, transaction, vm_state, vm_types],
  "."/[eip4844, gaslimit, withdrawals],
  nimcrypto/utils,
  stew/[objects, results]

from stew/byteutils
  import nil

export
  pow.PowRef,
  pow.new,
  results

{.push raises: [].}

func isGenesis(header: BlockHeader): bool =
  header.blockNumber == 0.u256 and
    header.parentHash == GENESIS_PARENT_HASH


proc validateHeader(com: CommonRef; header, parentHeader: BlockHeader;
                    numTransactions: int; checkSealOK: bool;
                    pow: PowRef): Result[void,string] =

  template inDAOExtraRange(blockNumber: BlockNumber): bool =
    # EIP-799
    # Blocks with block numbers in the range [1_920_000, 1_920_009]
    # MUST have DAOForkBlockExtra
    let daoForkBlock = com.daoForkBlock.get
    let DAOHigh = daoForkBlock + DAOForkExtraRange.u256
    daoForkBlock <= blockNumber and
      blockNumber < DAOHigh

  if header.extraData.len > 32:
    return err("BlockHeader.extraData larger than 32 bytes")

  if header.gasUsed == 0 and 0 < numTransactions:
    return err("zero gasUsed but tranactions present");

  if header.gasUsed < 0 or header.gasUsed > header.gasLimit:
    return err("gasUsed should be non negative and smaller or equal gasLimit")

  if header.blockNumber != parentHeader.blockNumber + 1:
    return err("Blocks must be numbered consecutively")

  if header.timestamp.toUnix <= parentHeader.timestamp.toUnix:
    return err("timestamp must be strictly later than parent")



  if com.consensus == ConsensusType.POS:
    # EIP-4399 and EIP-3675
    # no need to check mixDigest because EIP-4399 override this field
    # checking rule

    if not header.difficulty.isZero:
      return err("Non-zero difficulty in a post-merge block")

    if not header.nonce.isZeroMemory:
      return err("Non-zero nonce in a post-merge block")

    if header.ommersHash != EMPTY_UNCLE_HASH:
      return err("Invalid ommers hash in a post-merge block")
  else:
    let calcDiffc = com.calcDifficulty(header.timestamp, parentHeader)
    if header.difficulty < calcDiffc:
      return err("provided header difficulty is too low")

    if checkSealOK:
      return pow.validateSeal(header)

  ? com.validateWithdrawals(header)
  ? com.validateEip4844Header(header)

  ok()

func validateUncle(currBlock, uncle, uncleParent: BlockHeader):
                                               Result[void,string] =
  if uncle.blockNumber >= currBlock.blockNumber:
    return err("uncle block number larger than current block number")

  if uncle.blockNumber != uncleParent.blockNumber + 1:
    return err("Uncle number is not one above ancestor's number")

  if uncle.timestamp.toUnix < uncleParent.timestamp.toUnix:
    return err("Uncle timestamp is before ancestor's timestamp")

  if uncle.gasUsed > uncle.gasLimit:
    return err("Uncle's gas usage is above the limit")

  result = ok()


proc validateUncles(com: CommonRef; header: BlockHeader;
                    uncles: seq[BlockHeader]; checkSealOK: bool;
                    pow: PowRef): Result[void,string] =
  let hasUncles = uncles.len > 0
  let shouldHaveUncles = header.ommersHash != EMPTY_UNCLE_HASH

  if not hasUncles and not shouldHaveUncles:
    # optimization to avoid loading ancestors from DB, since the block has
    # no uncles
    return ok()
  if hasUncles and not shouldHaveUncles:
    return err("Block has uncles but header suggests uncles should be empty")
  if shouldHaveUncles and not hasUncles:
    return err("Header suggests block should have uncles but block has none")

  # Check for duplicates
  var uncleSet = initHashSet[Hash256]()
  for uncle in uncles:
    let uncleHash = uncle.blockHash
    if uncleHash in uncleSet:
      return err("Block contains duplicate uncles")
    else:
      uncleSet.incl uncleHash

  let chainDB = com.db
  let recentAncestorHashes = try:
    chainDB.getAncestorsHashes(MAX_UNCLE_DEPTH + 1, header)
  except CatchableError as err:
    return err("Block not present in database")

  let recentUncleHashes = try:
    chainDB.getUncleHashes(recentAncestorHashes)
  except CatchableError as err:
    return err("Ancenstors not present in database")

  let blockHash = header.blockHash

  for uncle in uncles:
    let uncleHash = uncle.blockHash

    if uncleHash == blockHash:
      return err("Uncle has same hash as block")

    # ensure the uncle has not already been included.
    if uncleHash in recentUncleHashes:
      return err("Duplicate uncle")

    # ensure that the uncle is not one of the canonical chain blocks.
    if uncleHash in recentAncestorHashes:
      return err("Uncle cannot be an ancestor")

    # ensure that the uncle was built off of one of the canonical chain
    # blocks.
    if (uncle.parentHash notin recentAncestorHashes) or
       (uncle.parentHash == header.parentHash):
      return err("Uncle's parent is not an ancestor")

    # check uncle against own parent
    var parent: BlockHeader
    if not chainDB.getBlockHeader(uncle.parentHash,parent):
      return err("Uncle's parent has gone missing")
    if uncle.timestamp <= parent.timestamp:
      return err("Uncle's parent must me older")

    # Now perform VM level validation of the uncle
    if checkSealOK:
      result = pow.validateSeal(uncle)
      if result.isErr:
        return

    let uncleParent = try:
      chainDB.getBlockHeader(uncle.parentHash)
    except BlockNotFound:
      return err("Uncle parent not found")

    result = validateUncle(header, uncle, uncleParent)
    if result.isErr:
      return

    result = com.validateGasLimitOrBaseFee(uncle, uncleParent)
    if result.isErr:
      return

  result = ok()

# ------------------------------------------------------------------------------
# Public function, extracted from executor
# ------------------------------------------------------------------------------

proc validateTransaction*(
    roDB:     ReadOnlyStateDB; ## Parent accounts environment for transaction
    tx:       Transaction;     ## tx to validate
    sender:   EthAddress;      ## tx.getSender or tx.ecRecover
    maxLimit: GasInt;          ## gasLimit from block header
    baseFee:  UInt256;         ## baseFee from block header
    fork:     EVMFork): Result[void, string] =
  let
    balance = roDB.getBalance(sender)
    nonce = roDB.getNonce(sender)

  if tx.txType == TxEip2930 and fork < FkBerlin:
    return err("invalid tx: Eip2930 Tx type detected before Berlin")

  if tx.txType == TxEip1559 and fork < FkLondon:
    return err("invalid tx: Eip1559 Tx type detected before London")

  if fork >= FkShanghai and tx.contractCreation and tx.payload.len > EIP3860_MAX_INITCODE_SIZE:
    return err("invalid tx: initcode size exceeds maximum")

  # Note that the following check bears some plausibility but is _not_
  # covered by the eip-1559 reference (sort of) pseudo code, for details
  # see `https://eips.ethereum.org/EIPS/eip-1559#specification`_
  #
  # Rather this check is needed for surviving the post-London unit test
  # eth_tests/GeneralStateTests/stEIP1559/lowGasLimit.json which seems to
  # be sourced and generated from
  # eth_tests/src/GeneralStateTestsFiller/stEIP1559/lowGasLimitFiller.yml
  #
  # Interestingly, the hive tests do not use this particular test but rather
  # eth_tests/BlockchainTests/GeneralStateTests/stEIP1559/lowGasLimit.json
  # from a parallel tests series which look like somehow expanded versions.
  #
  # The parallel lowGasLimit.json test never triggers the case checked below
  # as the paricular transaction is omitted (the txs list is just set empty.)
  try:
    if maxLimit < tx.gasLimit:
      return err("invalid tx: block header gasLimit exceeded. maxLimit=$1, gasLimit=$2" % [
        $maxLimit, $tx.gasLimit])

    # ensure that the user was willing to at least pay the base fee
    if tx.maxFee < baseFee.truncate(int64):
      return err("invalid tx: maxFee is smaller than baseFee. maxFee=$1, baseFee=$2" % [
        $tx.maxFee, $baseFee])

    # The total must be the larger of the two
    if tx.maxFee < tx.maxPriorityFee:
      return err("invalid tx: maxFee is smaller than maPriorityFee. maxFee=$1, maxPriorityFee=$2" % [
        $tx.maxFee, $tx.maxPriorityFee])

    # the signer must be able to fully afford the transaction
    let gasCost = if tx.txType >= TxEip1559:
                    tx.gasLimit.u256 * tx.maxFee.u256
                  else:
                    tx.gasLimit.u256 * tx.gasPrice.u256

    if balance < gasCost:
      return err("invalid tx: not enough cash for gas. avail=$1, require=$2" % [
        $balance, $gasCost])

    if balance - gasCost < tx.value:
      return err("invalid tx: not enough cash to send. avail=$1, availMinusGas=$2, require=$3" % [
        $balance, $(balance-gasCost), $tx.value])

    if tx.gasLimit < tx.intrinsicGas(fork):
      return err("invalid tx: not enough gas to perform calculation. avail=$1, require=$2" % [
        $tx.gasLimit, $tx.intrinsicGas(fork)])

    if tx.nonce != nonce:
      return err("invalid tx: account nonce mismatch. txNonce=$1, accNonce=$2" % [
        $tx.nonce, $nonce])

    if tx.nonce == high(uint64):
      return err("invalid tx: nonce at maximum")

    # EIP-3607 Reject transactions from senders with deployed code
    # The EIP spec claims this attack never happened before
    # Clients might choose to disable this rule for RPC calls like
    # `eth_call` and `eth_estimateGas`
    # EOA = Externally Owned Account
    let codeHash = roDB.getCodeHash(sender)
    if codeHash != EMPTY_SHA3:
      return err("invalid tx: sender is not an EOA. sender=$1, codeHash=$2" % [
        sender.toHex, codeHash.data.toHex])
  except CatchableError as ex:
    return err(ex.msg)

  ok()

proc validateTransaction*(
    vmState: BaseVMState;  ## Parent accounts environment for transaction
    tx:      Transaction;  ## tx to validate
    sender:  EthAddress;   ## tx.getSender or tx.ecRecover
    header:  BlockHeader;  ## Header for the block containing the current tx
    fork:    EVMFork): Result[void, string] =
  ## Variant of `validateTransaction()`
  let
    roDB = vmState.readOnlyStateDB
    gasLimit = header.gasLimit
    baseFee = header.baseFee
  roDB.validateTransaction(tx, sender, gasLimit, baseFee, fork)

# ------------------------------------------------------------------------------
# Public functions, extracted from test_blockchain_json
# ------------------------------------------------------------------------------

proc validateHeaderAndKinship*(
    com: CommonRef;
    header: BlockHeader;
    uncles: seq[BlockHeader];
    numTransactions: int;
    checkSealOK: bool;
    pow: PowRef): Result[void, string] =
  if header.isGenesis:
    if header.extraData.len > 32:
      return err("BlockHeader.extraData larger than 32 bytes")
    return ok()

  let chainDB = com.db
  let parent = try:
    chainDB.getBlockHeader(header.parentHash)
  except CatchableError as err:
    return err("Failed to load block header from DB")

  result = com.validateHeader(
    header, parent, numTransactions, checkSealOK, pow)
  if result.isErr:
    return

  if uncles.len > MAX_UNCLES:
    return err("Number of uncles exceed limit.")

  if not chainDB.exists(header.stateRoot):
    return err("`state_root` was not found in the db.")

  if com.consensus != ConsensusType.POS:
    result = com.validateUncles(header, uncles, checkSealOK, pow)

  if result.isOk:
    result = com.validateGasLimitOrBaseFee(header, parent)

proc validateHeaderAndKinship*(
    com: CommonRef;
    header: BlockHeader;
    body: BlockBody;
    checkSealOK: bool;
    pow: PowRef): Result[void, string] =

  com.validateHeaderAndKinship(
    header, body.uncles, body.transactions.len, checkSealOK, pow)

proc validateHeaderAndKinship*(
    com: CommonRef;
    ethBlock: EthBlock;
    checkSealOK: bool;
    pow: PowRef): Result[void,string] =
  com.validateHeaderAndKinship(
    ethBlock.header, ethBlock.uncles, ethBlock.txs.len,
    checkSealOK, pow)

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
