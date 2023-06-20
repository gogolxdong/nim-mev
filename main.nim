import
  std/[os, strutils, net],
  chronicles,
  chronos,
  eth/[keys, net/nat],
  eth/p2p as eth_p2p,
  metrics,
  stew/shims/net as stewNet,
  websock/websock as ws,
  "."/[config, constants, version, common,vm_compile_info],
  ./core/[tx_pool, block_import]

type
  NimbusState = enum
    Starting, Running, Stopping

  NimbusNode = ref object
    ethNode: EthereumNode
    ctx: EthContext
    txPool: TxPoolRef
    networkLoop: Future[void]
    peerManager: PeerManagerRef

proc setupP2P(nimbus: NimbusNode, conf: NimbusConf, protocols: set[ProtocolFlag]) =
  let kpres = nimbus.ctx.getNetKeys(conf.netKey, conf.dataDir.string)
  if kpres.isErr:
    fatal "Get network keys error", msg = kpres.error
    quit(QuitFailure)

  let keypair = kpres.get()
  var address = Address(ip: conf.listenAddress,tcpPort: conf.tcpPort,udpPort: conf.udpPort)

  if conf.nat.hasExtIp:
    address.ip = conf.nat.extIp
  else:
    let extIP = getExternalIP(conf.nat.nat)
    if extIP.isSome:
      address.ip = extIP.get()
      let extPorts = redirectPorts(tcpPort = address.tcpPort,
                                   udpPort = address.udpPort,
                                   description = NimbusName & " " & NimbusVersion)
      if extPorts.isSome:
        (address.tcpPort, address.udpPort) = extPorts.get()

  let bootstrapNodes = conf.getBootNodes()

  nimbus.ethNode = newEthereumNode(
    keypair, address, conf.networkId, conf.agentString,
    addAllCapabilities = false, minPeers = conf.maxPeers,
    bootstrapNodes = bootstrapNodes,
    bindUdpPort = conf.udpPort, bindTcpPort = conf.tcpPort,
    bindIp = conf.listenAddress,
    rng = nimbus.ctx.rng)

  for w in protocols:
    case w: 
    of ProtocolFlag.Eth:
      nimbus.ethNode.addEthHandlerCapability(
        nimbus.ethNode.peerPool,
        nimbus.chainRef,
        nimbus.txPool)
  if ProtocolFlag.Eth notin protocols:
    nimbus.ethNode.addEthHandlerCapability(
      nimbus.ethNode.peerPool,
      nimbus.chainRef)

  let staticPeers = conf.getStaticPeers()
  if staticPeers.len > 0:
    nimbus.peerManager = PeerManagerRef.new(
      nimbus.ethNode.peerPool,
      conf.reconnectInterval,
      conf.reconnectMaxRetry,
      staticPeers
    )
    nimbus.peerManager.start()

  if conf.maxPeers > 0:
    var waitForPeers = false

    nimbus.networkLoop = nimbus.ethNode.connectToNetwork(
      enableDiscovery = conf.discovery != DiscoveryType.None,
      waitForPeers = waitForPeers)

proc start(nimbus: NimbusNode, conf: NimbusConf) =
  setLogLevel(conf.logLevel)
  if conf.logFile.isSome:
    let logFile = string conf.logFile.get()
    defaultChroniclesStream.output.outFile = nil 
    discard defaultChroniclesStream.output.open(logFile, fmAppend)

  when defined(evmc_enabled):
    evmcSetLibraryPath(conf.evm)

  let protocols = conf.getProtocolFlags()

  case conf.cmd
  of NimbusCmd.`import`:
    importBlocks(conf, com)
  else:
    setupP2P(nimbus, conf, protocols)

    if nimbus.state == Starting:
      nimbus.state = Running

proc stop*(nimbus: NimbusNode, conf: NimbusConf) {.async, gcsafe.} =
  trace "Graceful shutdown"
  if conf.maxPeers > 0:
    await nimbus.networkLoop.cancelAndWait()
  if nimbus.peerManager.isNil.not:
    await nimbus.peerManager.stop()

proc process*(nimbus: NimbusNode, conf: NimbusConf) =
  while nimbus.state == Running:
    try:
      poll()
    except CatchableError as e:
      debug "Exception in poll()", exc = e.name, err = e.msg
      discard e # silence warning when chronicles not activated

  waitFor nimbus.stop(conf)

when isMainModule:
  var nimbus = NimbusNode(state: Starting, ctx: newEthContext())

  proc controlCHandler() {.noconv.} =
    when defined(windows):
      setupForeignThreadGc()
    nimbus.state = Stopping
    echo "\nCtrl+C pressed. Waiting for a graceful shutdown."
  setControlCHook(controlCHandler)

  discard defaultChroniclesStream.output.open(stdout)

  let conf = makeConfig()

  nimbus.start(conf)
  nimbus.process(conf)
