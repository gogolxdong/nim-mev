import eth/[p2p,common], bearssl/hash as bhash, bearssl/rand
import chronos
import eth/p2p/[rlpx,ecies,peer_pool, discovery, bootnodes], stew/[byteutils]
import ./sync/protocol
import std/random, os, strutils
import ./common, ./common/chain_config, ./common/evmc/evmc
import ./db/select_backend
import ./evm/[evmc_api,types, state]
import ./core/chain/chain_desc, ./core/tx_pool
import ./sync/handlers/setup
import ./sync/[handlers,legacy]
# import lmdb
import rocksdb
import sequtils
import ./config

template toa(a, b, c: untyped): untyped =
  toOpenArray((a), (b), (b) + (c) - 1)

var nextPort = Port 30312

# var node1 = ENode.fromString("enode://1cc4534b14cfe351ab740a1418ab944a234ca2f702915eadb7e558a02010cb7c5a8c295a3b56bcefa7701c07752acd5539cb13df2aab8ae2d98934d712611443@52.71.43.172:30311").get
# var node2 = ENode.fromString("enode://28b1d16562dac280dacaaf45d54516b85bc6c994252a9825c5cc4e080d3e53446d05f63ba495ea7d44d6c316b54cd92b245c5c328c37da24605c4a93a0d099c4@34.246.65.14:30311").get
# var node3 = ENode.fromString("enode://5a7b996048d1b0a07683a949662c87c09b55247ce774aeee10bb886892e586e3c604564393292e38ef43c023ee9981e1f8b335766ec4f0f256e57f8640b079d5@35.73.137.11:30311").get
# var node4 = ENode.fromString("enode://22f27e4df6e569cce7bfca6c8c0d5a1f49a608a50dd34ee9eb79c8c9fcb8afda012595794db4a0a4d51ca9f26c33ad19c7602177ed438043571924641a3d3783@144.202.109.99:30311").get
var node5 = ENode.fromString("enode://c641e6b3cb4754e3a0a2d85175f49df45febf9b164dea29e76a94e704dd542343fbd861b0c251cf7c72f38a436eb9f250832f80c22d3aaf3d755a6264f1c85d3@149.28.74.252:30311").get

var pk = PrivateKey.fromHex(readFile("key")).get

proc setupNode*(rng: ref HmacDrbgContext, capabilities: varargs[ProtocolInfo, `protocolInfo`]): EthereumNode {.gcsafe.} =
  {.gcsafe.}:
    var bootstrapNodes = BSCBootnodes.mapIt(ENode.fromString(it).get)
    result = newEthereumNode(pk.toKeyPair, 
      Address(udpPort: nextPort, tcpPort: nextPort, ip: parseIpAddress("0.0.0.0")), 
      NetworkId(56), 
      addAllCapabilities = false, 
      bootstrapNodes=bootstrapNodes,
      bindUdpPort = nextPort, 
      bindTcpPort = nextPort,
      rng = rng)

    var dbBackend = newChainDB(getCurrentDir() / ".rocksdb")
    let trieDB = trieDB dbBackend
    let comm = CommonRef.new(trieDB, pruneTrie=false, config.BSC, networkParams(config.BSC))
    comm.initializeEmptyDb()
    var chain = comm.newChain()
    var txPool = TxPoolRef.new(comm, pk.toPublicKey.toCanonicalAddress)   

    for capability in capabilities:
      result.addCapability capability , EthWireRef.new(chain, txPool, result.peerPool)

    # var legaSyncRef = LegacySyncRef.new(result, chain)
    # result.setEthHandlerNewBlocksAndHashes(legacy.newBlockHandler, legacy.newBlockHashesHandler, cast[pointer](legaSyncRef))

var rng = newRng()
var node = setupNode(rng, eth )
var peer:Peer

proc startNode() =
  node.startListening()

  var res = waitFor node.rlpxConnect(newNode node5)
  if res.isOk:
    peer = res.get
  else:
    echo res.error
    quit 1

  proc controlCHandler() {.noconv.} =
    info "\nCtrl+C pressed. Waiting for a graceful shutdown."
    node.stopListening()
    info "stopListening"
    node.peerPool.running = false
    if peer != nil:
      waitFor peer.disconnect(ClientQuitting, true)
      info "disconnect"
  setControlCHook(controlCHandler)

  # node.peerPool.start()
  # while node.peerPool.running:
  #   poll()

  while true:
    if peer.connectionState != Connected:
      break
    poll()

proc defaultDataDir*(): string =
  when defined(windows):
    getCurrentDir() / "AppData" / "Roaming" / "Nimbus"
  elif defined(macosx):
    getCurrentDir() / "Library" / "Application Support" / "Nimbus"
  else:
    getCurrentDir() / ".lmdb" 

proc defaultKeystoreDir*(): string =
  getCurrentDir() / "keystore"

proc toData*(s: string): seq[byte] {.compileTime.} = s.strip().hexToSeqByte()

proc nim_host_create_context(tx_context: var evmc_tx_context): evmc_host_context {.importc, cdecl.}
proc nim_host_get_interface*(): ptr nimbus_host_interface {.importc, cdecl.}
proc nim_host_create_context*(vmstate: pointer, msg: ptr evmc_message): evmc_host_context {.importc, cdecl.}
proc nim_host_destroy_context*(ctx: evmc_host_context) {.importc, cdecl.}
proc nim_create_nimbus_vm*(): ptr evmc_vm {.importc, cdecl.}


startNode()
# node.peerPool.start()
# while true:
#   if not node.peerPool.running:
#     break
#   poll()

# node.discovery.open()
# waitFor node.discovery.bootstrap()
