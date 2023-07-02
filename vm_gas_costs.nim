
import
  ./evm/interpreter/gas_costs as vmg

export
  vmg.Bls12381G1AddGas,
  vmg.Bls12381G1MulGas,
  vmg.Bls12381G2AddGas,
  vmg.Bls12381G2MulGas,
  vmg.Bls12381MapG1Gas,
  vmg.Bls12381MapG2Gas,
  vmg.Bls12381PairingBaseGas,
  vmg.Bls12381PairingPerPairGas,
  vmg.ColdAccountAccessCost,
  vmg.ColdSloadCost,
  vmg.GasCostKind,
  vmg.GasCosts,
  vmg.GasECAdd,
  vmg.GasECAddIstanbul,
  vmg.GasECMul,
  vmg.GasECMulIstanbul,
  vmg.GasECPairingBase,
  vmg.GasECPairingBaseIstanbul,
  vmg.GasECPairingPerPoint,
  vmg.GasECPairingPerPointIstanbul,
  vmg.GasECRecover,
  vmg.GasFeeKind,
  vmg.GasIdentity,
  vmg.GasIdentityWord,
  vmg.GasParams,
  vmg.GasQuadDivisorEIP2565,
  vmg.GasRIPEMD160,
  vmg.GasRIPEMD160Word,
  vmg.GasSHA256,
  vmg.GasSHA256Word,
  vmg.WarmStorageReadCost,
  vmg.forkToSchedule,
  vmg.gasFees,
  vmg.ACCESS_LIST_STORAGE_KEY_COST,
  vmg.ACCESS_LIST_ADDRESS_COST

when defined(evmc_enabled):
  export
    vmg.SstoreCost

# End
