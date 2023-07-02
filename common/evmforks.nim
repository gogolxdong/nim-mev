import ./evmc/evmc

type
  EVMFork* = evmc_revision

const
  FkFrontier*       = EVMC_FRONTIER
  FkHomestead*      = EVMC_HOMESTEAD
  FkTangerine*      = EVMC_TANGERINE_WHISTLE
  FkSpurious*       = EVMC_SPURIOUS_DRAGON
  FkByzantium*      = EVMC_BYZANTIUM
  FkConstantinople* = EVMC_CONSTANTINOPLE
  FkPetersburg*     = EVMC_PETERSBURG
  FkIstanbul*       = EVMC_ISTANBUL
  FkBerlin*         = EVMC_BERLIN
  FkLondon*         = EVMC_LONDON
  FkParis*          = EVMC_PARIS
  FkShanghai*       = EVMC_SHANGHAI
  FkCancun*         = EVMC_CANCUN
