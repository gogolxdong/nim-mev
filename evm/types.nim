import
  std/[json, sets],
  chronos,
  json_rpc/rpcclient,
  "."/[stack, memory, code_stream],
  ./interpreter/[gas_costs, op_codes],
  ./async/data_sources,
  ../db/accounts_cache,
  ../common/[common, evmforks]

{.push raises: [].}

when defined(evmc_enabled):
  import
    ./evmc_api

const vm_use_recursion* = defined(evmc_enabled)

type
  VMFlag* = enum
    ExecutionOK
    GenerateWitness
    ClearCache

  BaseVMState* = ref object of RootObj
    prevHeaders*   : seq[BlockHeader]
    com*           : CommonRef
    gasPool*       : GasInt
    parent*        : BlockHeader
    timestamp*     : EthTime
    gasLimit*      : GasInt
    fee*           : Option[UInt256]
    prevRandao*    : Hash256
    blockDifficulty*: UInt256
    flags*         : set[VMFlag]
    tracer*        : TransactionTracer
    receipts*      : seq[Receipt]
    stateDB*       : AccountsCache
    cumulativeGasUsed*: GasInt
    txOrigin*      : EthAddress
    txGasPrice*    : GasInt
    txVersionedHashes*: VersionedHashes
    gasCosts*      : GasCosts
    fork*          : EVMFork
    minerAddress*  : EthAddress
    asyncFactory*  : AsyncOperationFactory

  TracerFlags* {.pure.} = enum
    EnableTracing
    DisableStorage
    DisableMemory
    DisableStack
    DisableState
    DisableStateDiff
    EnableAccount
    DisableReturnData
    GethCompatibility

  TransactionTracer* = object
    trace*: JsonNode
    flags*: set[TracerFlags]
    accounts*: HashSet[EthAddress]
    storageKeys*: seq[HashSet[UInt256]]
    gasUsed*: GasInt

  Computation* = ref object
    # The execution computation
    vmState*:               BaseVMState
    msg*:                   Message
    memory*:                Memory
    stack*:                 Stack
    returnStack*:           seq[int]
    gasMeter*:              GasMeter
    code*:                  CodeStream
    output*:                seq[byte]
    returnData*:            seq[byte]
    error*:                 Error
    savePoint*:             SavePoint
    instr*:                 Op
    opIndex*:               int
    when defined(evmc_enabled):
      host*:                HostContext
      child*:               ref nimbus_message
      res*:                 nimbus_result
    else:
      parent*, child*:      Computation
    pendingAsyncOperation*: Future[void]
    continuation*:          proc() {.gcsafe, raises: [CatchableError].}

  Error* = ref object
    info*:                  string
    burnsGas*:              bool

  GasMeter* = object
    gasRefunded*: GasInt
    gasRemaining*: GasInt

  CallKind* = enum
    evmcCall         = 0, # CALL
    evmcDelegateCall = 1, # DELEGATECALL
    evmcCallCode     = 2, # CALLCODE
    evmcCreate       = 3, # CREATE
    evmcCreate2      = 4  # CREATE2

  MsgFlags* = enum
    emvcNoFlags  = 0
    emvcStatic   = 1

  Message* = ref object
    kind*:             CallKind
    depth*:            int
    gas*:              GasInt
    sender*:           EthAddress
    contractAddress*:  EthAddress
    codeAddress*:      EthAddress
    value*:            UInt256
    data*:             seq[byte]
    flags*:            MsgFlags
