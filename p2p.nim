import eth/[p2p,common], bearssl/hash as bhash, bearssl/rand
import chronos
import eth/p2p/[rlpx,ecies,peer_pool, discovery]
import ./protocols
import std/random

template toa(a, b, c: untyped): untyped =
  toOpenArray((a), (b), (b) + (c) - 1)

var nextPort = Port 30312

var node1 = ENode.fromString("enode://1cc4534b14cfe351ab740a1418ab944a234ca2f702915eadb7e558a02010cb7c5a8c295a3b56bcefa7701c07752acd5539cb13df2aab8ae2d98934d712611443@52.71.43.172:30311").get
var node2 = ENode.fromString("enode://28b1d16562dac280dacaaf45d54516b85bc6c994252a9825c5cc4e080d3e53446d05f63ba495ea7d44d6c316b54cd92b245c5c328c37da24605c4a93a0d099c4@34.246.65.14:30311").get
var node3 = ENode.fromString("enode://5a7b996048d1b0a07683a949662c87c09b55247ce774aeee10bb886892e586e3c604564393292e38ef43c023ee9981e1f8b335766ec4f0f256e57f8640b079d5@35.73.137.11:30311").get
var node4 = ENode.fromString("enode://22f27e4df6e569cce7bfca6c8c0d5a1f49a608a50dd34ee9eb79c8c9fcb8afda012595794db4a0a4d51ca9f26c33ad19c7602177ed438043571924641a3d3783@144.202.109.99:30311").get
var node5 = ENode.fromString("enode://c641e6b3cb4754e3a0a2d85175f49df45febf9b164dea29e76a94e704dd542343fbd861b0c251cf7c72f38a436eb9f250832f80c22d3aaf3d755a6264f1c85d3@149.28.74.252:30311").get

var pk = PrivateKey.fromHex("0x21e4a26d7699c1db44cfd6303c8f969c3ab6c9e31bdc13d3ad5bfda7a180c9a5").get
proc setupTestNode*(
    rng: ref HmacDrbgContext,
    capabilities: varargs[ProtocolInfo, `protocolInfo`]): EthereumNode {.gcsafe.} =
  
  var bootstrapNodes = @[node5]

  result = newEthereumNode(pk.toKeyPair, Address(udpPort: nextPort, tcpPort: nextPort, ip: parseIpAddress("0.0.0.0")), NetworkId(56), 
    addAllCapabilities = false, bootstrapNodes=bootstrapNodes,
    bindUdpPort = nextPort, bindTcpPort = nextPort,
    rng = rng)
  for capability in capabilities:
    result.addCapability capability

var rng = newRng()

var peer:Peer
var node = setupTestNode(rng, eth )
node.startListening()

proc controlCHandler() {.noconv.} =
  echo "\nCtrl+C pressed. Waiting for a graceful shutdown."
  node.stopListening()
  echo "stopListening"
  node.peerPool.running = false
  if peer != nil:
    waitFor peer.disconnect(ClientQuitting, true)
  echo "disconnect"
setControlCHook(controlCHandler)

var res = waitFor node.rlpxConnect(newNode node5)
if res.isOk:
  peer = res.get
else:
  echo res.error
  quit 1
while true:
  if peer.connectionState != Connected:
    break
  poll()

# node.peerPool.start()
# while true:
#   if not node.peerPool.running:
#     break
#   poll()

# node.discovery.open()
# waitFor node.discovery.bootstrap()
