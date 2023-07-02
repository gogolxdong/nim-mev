import
  ./evm/computation as vmc,
  ./evm/interpreter_dispatch as vmi
export
  vmi.execCallOrCreate,
  vmi.executeOpcodes

export
  vmc.accountExists,
  vmc.addLogEntry,
  vmc.chainTo,
  vmc.commit,
  vmc.dispose,
  vmc.execSelfDestruct,
  vmc.fork,
  vmc.getBalance,
  vmc.getBlockHash,
  vmc.getBlockNumber,
  vmc.getChainId,
  vmc.getCode,
  vmc.getCodeHash,
  vmc.getCodeSize,
  vmc.getCoinbase,
  vmc.getDifficulty,
  vmc.getGasLimit,
  vmc.getGasPrice,
  vmc.getGasRefund,
  vmc.getOrigin,
  vmc.getStorage,
  vmc.getTimestamp,
  vmc.isError,
  vmc.isOriginComputation,
  vmc.isSuccess,
  vmc.merge,
  vmc.newComputation,
  vmc.prepareTracer,
  vmc.refundSelfDestruct,
  vmc.rollback,
  vmc.selfDestruct,
  vmc.setError,
  vmc.shouldBurnGas,
  vmc.snapshot,
  vmc.traceError,
  vmc.traceOpCodeEnded,
  vmc.traceOpCodeStarted,
  vmc.tracingEnabled,
  vmc.writeContract

# End
