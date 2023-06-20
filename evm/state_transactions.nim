import
  chronos,
  eth/common/eth_types,
  ../constants,
  ../transaction,
  ./computation,
  ./interpreter_dispatch,
  ./interpreter/gas_costs,
  ./message,
  ./state,
  ./types

{.push raises: [].}

proc setupTxContext*(vmState: BaseVMState, origin: EthAddress, gasPrice: GasInt, forkOverride=none(EVMFork)) =
  vmState.txOrigin = origin
  vmState.txGasPrice = gasPrice
  vmState.fork =
    if forkOverride.isSome:
      forkOverride.get
    else:
      vmState.determineFork
  vmState.gasCosts = vmState.fork.forkToSchedule


proc preExecComputation(c: Computation) =
  if not c.msg.isCreate:
    c.vmState.mutateStateDB:
      db.incNonce(c.msg.sender)

proc postExecComputation(c: Computation) =
  if c.isSuccess:
    if c.fork < FkLondon:
      # EIP-3529: Reduction in refunds
      c.refundSelfDestruct()
  c.vmState.status = c.isSuccess

proc execComputation*(c: Computation)
    {.gcsafe, raises: [CatchableError].} =
  c.preExecComputation()
  c.execCallOrCreate()
  c.postExecComputation()

# FIXME-duplicatedForAsync
proc asyncExecComputation*(c: Computation): Future[void] {.async.} =
  c.preExecComputation()
  await c.asyncExecCallOrCreate()
  c.postExecComputation()
