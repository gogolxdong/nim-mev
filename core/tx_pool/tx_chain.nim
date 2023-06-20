import
  std/times,
  ../../common,
  ../../constants,
  ../../utils/utils,
  ../../vm_state,
  ../../vm_types,
  ../executor,
  ../casper,
  ./tx_chain/[tx_basefee, tx_gaslimits],
  ./tx_item

export
  TxChainGasLimits,
  TxChainGasLimitsPc

{.push raises: [].}

const
  TRG_THRESHOLD_PER_CENT = 
    90

  MAX_THRESHOLD_PER_CENT = 
    90

type
  TxChainPackerEnv = tuple
    vmState: BaseVMState     
    receipts: seq[Receipt]   
    reward: UInt256          
    profit: UInt256         
    txRoot: Hash256          
    stateRoot: Hash256       

  TxChainRef* = ref object 
    com: CommonRef           
    miner: EthAddress        
    lhwm: TxChainGasLimitsPc 

    maxMode: bool            
    roAcc: ReadOnlyStateDB   
    limits: TxChainGasLimits 
    txEnv: TxChainPackerEnv  
    prepHeader: BlockHeader  
    withdrawals: seq[Withdrawal] 

proc prepareHeader(dh: TxChainRef; parent: BlockHeader, timestamp: EthTime)
     {.gcsafe, raises: [CatchableError].} =

  case dh.com.consensus
  of ConsensusType.POW:
    dh.prepHeader.timestamp  = timestamp
    dh.prepHeader.difficulty = dh.com.calcDifficulty(
      dh.prepHeader.timestamp, parent)
    dh.prepHeader.coinbase   = dh.miner
    dh.prepHeader.mixDigest.reset
  of ConsensusType.POA:
    discard dh.com.poa.prepare(parent, dh.prepHeader)
    dh.prepHeader.coinbase = dh.miner
  of ConsensusType.POS:
    dh.com.pos.prepare(dh.prepHeader)

proc prepareForSeal(dh: TxChainRef; header: var BlockHeader) {.gcsafe, raises: [].} =
  case dh.com.consensus
  of ConsensusType.POW:
    discard
  of ConsensusType.POA:
    dh.com.poa.prepareForSeal(dh.prepHeader, header)
  of ConsensusType.POS:
    dh.com.pos.prepareForSeal(header)

proc getTimestamp(dh: TxChainRef, parent: BlockHeader): EthTime =
  case dh.com.consensus
  of ConsensusType.POW:
    getTime().utc.toTime
  of ConsensusType.POA:
    let timestamp = parent.timestamp + dh.com.poa.cfg.period
    if timestamp < getTime():
      getTime()
    else:
      timestamp
  of ConsensusType.POS:
    dh.com.pos.timestamp

proc resetTxEnv(dh: TxChainRef; parent: BlockHeader; fee: Option[UInt256])
  {.gcsafe,raises: [CatchableError].} =
  dh.txEnv.reset

  let timestamp = dh.getTimestamp(parent)
  dh.com.hardForkTransition(parent.blockHash, parent.blockNumber+1, some(timestamp))
  dh.prepareHeader(parent, timestamp)

  dh.txEnv.vmState = BaseVMState.new(
    parent    = parent,
    timestamp = dh.prepHeader.timestamp,
    gasLimit  = (if dh.maxMode: dh.limits.maxLimit else: dh.limits.trgLimit),
    fee       = fee,
    prevRandao= dh.prepHeader.prevRandao,
    difficulty= dh.prepHeader.difficulty,
    miner     = dh.prepHeader.coinbase,
    com       = dh.com)

  dh.txEnv.txRoot = EMPTY_ROOT_HASH
  dh.txEnv.stateRoot = dh.txEnv.vmState.parent.stateRoot

proc update(dh: TxChainRef; parent: BlockHeader)
    {.gcsafe,raises: [CatchableError].} =

  let
    timestamp = dh.getTimestamp(parent)
    db  = dh.com.db
    acc = AccountsCache.init(db.db, parent.stateRoot, dh.com.pruneTrie)
    fee = if dh.com.isLondon(parent.blockNumber + 1, timestamp):
            some(dh.com.baseFeeGet(parent).uint64.u256)
          else:
            UInt256.none()

  dh.roAcc = ReadOnlyStateDB(acc)

  dh.limits = dh.com.gasLimitsGet(parent, dh.lhwm)
  dh.resetTxEnv(parent, fee)

proc new*(T: type TxChainRef; com: CommonRef; miner: EthAddress): T
    {.gcsafe,raises: [CatchableError].} =
  new result

  result.com = com
  result.miner = miner
  result.lhwm.lwmTrg = TRG_THRESHOLD_PER_CENT
  result.lhwm.hwmMax = MAX_THRESHOLD_PER_CENT
  result.lhwm.gasFloor = DEFAULT_GAS_LIMIT
  result.lhwm.gasCeil  = DEFAULT_GAS_LIMIT
  result.update(com.db.getCanonicalHead)


proc getBalance*(dh: TxChainRef; account: EthAddress): UInt256 =
  dh.roAcc.getBalance(account)

proc getNonce*(dh: TxChainRef; account: EthAddress): AccountNonce =
  dh.roAcc.getNonce(account)

proc getHeader*(dh: TxChainRef): BlockHeader
    {.gcsafe,raises: [CatchableError].} =
  let gasUsed = if dh.txEnv.receipts.len == 0: 0.GasInt
                else: dh.txEnv.receipts[^1].cumulativeGasUsed

  result = BlockHeader(
    parentHash:  dh.txEnv.vmState.parent.blockHash,
    ommersHash:  EMPTY_UNCLE_HASH,
    coinbase:    dh.prepHeader.coinbase,
    stateRoot:   dh.txEnv.stateRoot,
    txRoot:      dh.txEnv.txRoot,
    receiptRoot: dh.txEnv.receipts.calcReceiptRoot,
    bloom:       dh.txEnv.receipts.createBloom,
    difficulty:  dh.prepHeader.difficulty,
    blockNumber: dh.txEnv.vmState.blockNumber,
    gasLimit:    dh.txEnv.vmState.gasLimit,
    gasUsed:     gasUsed,
    timestamp:   dh.prepHeader.timestamp,
    fee:         dh.txEnv.vmState.fee)

  if dh.com.forkGTE(Shanghai):
    result.withdrawalsRoot = some(calcWithdrawalsRoot(dh.withdrawals))

  dh.prepareForSeal(result)

proc clearAccounts*(dh: TxChainRef)
    {.gcsafe,raises: [CatchableError].} =
  dh.resetTxEnv(dh.txEnv.vmState.parent, dh.txEnv.vmState.fee)


proc com*(dh: TxChainRef): CommonRef =
  dh.com

proc head*(dh: TxChainRef): BlockHeader =
  dh.txEnv.vmState.parent

proc limits*(dh: TxChainRef): TxChainGasLimits =
  dh.limits

proc lhwm*(dh: TxChainRef): TxChainGasLimitsPc =
  dh.lhwm

proc maxMode*(dh: TxChainRef): bool =
  dh.maxMode

proc feeRecipient*(dh: TxChainRef): EthAddress =
  if dh.com.consensus == ConsensusType.POS:
    dh.com.pos.feeRecipient
  else:
    dh.miner

proc baseFee*(dh: TxChainRef): GasPrice =
  if dh.txEnv.vmState.fee.isSome:
    dh.txEnv.vmState.fee.get.truncate(uint64).GasPrice
  else:
    0.GasPrice

proc nextFork*(dh: TxChainRef): EVMFork =
  dh.com.toEVMFork(dh.txEnv.vmState.forkDeterminationInfoForVMState)

proc gasUsed*(dh: TxChainRef): GasInt =
  if 0 < dh.txEnv.receipts.len:
    return dh.txEnv.receipts[^1].cumulativeGasUsed

proc profit*(dh: TxChainRef): UInt256 =
  dh.txEnv.profit

proc receipts*(dh: TxChainRef): seq[Receipt] =
  dh.txEnv.receipts

proc reward*(dh: TxChainRef): UInt256 =
  dh.txEnv.reward

proc stateRoot*(dh: TxChainRef): Hash256 =
  dh.txEnv.stateRoot

proc txRoot*(dh: TxChainRef): Hash256 =
  dh.txEnv.txRoot

proc vmState*(dh: TxChainRef): BaseVMState =
  dh.txEnv.vmState

proc withdrawals*(dh: TxChainRef): seq[Withdrawal] =
  result = system.move(dh.withdrawals)

proc `baseFee=`*(dh: TxChainRef; val: GasPrice) =
  if 0 < val or dh.com.isLondon(dh.txEnv.vmState.blockNumber):
    dh.txEnv.vmState.fee = some(val.uint64.u256)
  else:
    dh.txEnv.vmState.fee = UInt256.none()

proc `head=`*(dh: TxChainRef; val: BlockHeader)
    {.gcsafe,raises: [CatchableError].} =
  dh.update(val)

proc `lhwm=`*(dh: TxChainRef; val: TxChainGasLimitsPc) =
  if dh.lhwm != val:
    dh.lhwm = val
    let parent = dh.txEnv.vmState.parent
    dh.limits = dh.com.gasLimitsGet(parent, dh.limits.gasLimit, dh.lhwm)
    dh.txEnv.vmState.gasLimit = if dh.maxMode: dh.limits.maxLimit
                                else:          dh.limits.trgLimit

proc `maxMode=`*(dh: TxChainRef; val: bool) =
  dh.maxMode = val
  dh.txEnv.vmState.gasLimit = if dh.maxMode: dh.limits.maxLimit
                              else:          dh.limits.trgLimit

proc `miner=`*(dh: TxChainRef; val: EthAddress) =
  dh.miner = val
  dh.txEnv.vmState.minerAddress = val

proc `profit=`*(dh: TxChainRef; val: UInt256) =
  dh.txEnv.profit = val

proc `receipts=`*(dh: TxChainRef; val: seq[Receipt]) =
  dh.txEnv.receipts = val

proc `reward=`*(dh: TxChainRef; val: UInt256) =
  dh.txEnv.reward = val

proc `stateRoot=`*(dh: TxChainRef; val: Hash256) =
  dh.txEnv.stateRoot = val

proc `txRoot=`*(dh: TxChainRef; val: Hash256) =
  dh.txEnv.txRoot = val

proc `withdrawals=`*(dh: TxChainRef, val: sink seq[Withdrawal]) =
  dh.withdrawals = system.move(val)