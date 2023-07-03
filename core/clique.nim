import
  std/[times],
  ./clique/[clique_cfg, clique_defs, clique_desc],
  ./clique/snapshot/[ballot, snapshot_desc],
  stew/results

{.push raises: [].}

export
  clique_cfg,
  clique_defs,
  clique_desc.Clique

type
  CliqueState* = 
    Result[Snapshot,void]


proc newClique*(db: ChainDBRef, cliquePeriod, cliqueEpoch: int): Clique =
  let cfg = db.newCliqueCfg
  if cliquePeriod > 0:
    cfg.period = initDuration(seconds = cliquePeriod)
  if cliqueEpoch > 0:
    cfg.epoch = cliqueEpoch
  cfg.newClique

proc cliqueSave*(c: Clique): CliqueState =
  ok(c.snapshot)

proc cliqueRestore*(c: Clique; state: var CliqueState) =
  if state.isOk:
    c.snapshot = state.value

proc cliqueDispose*(c: Clique; state: var CliqueState) =
  state = err(CliqueState)

proc cliqueSigners*(c: Clique): seq[EthAddress] =
  c.snapshot.ballot.authSigners

proc cliqueSignersLen*(c: Clique): int =
  c.snapshot.ballot.authSignersLen
