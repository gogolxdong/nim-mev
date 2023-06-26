import eth/[p2p], bearssl/hash as bhash, bearssl/rand
import chronos
import eth/p2p/rlpx
import ./protocols

var nextPort = 30311

proc localAddress*(port: int): Address =
  let port = Port(port)
  result = Address(udpPort: port, tcpPort: port,
                   ip: parseIpAddress("0.0.0.0"))

proc setupTestNode*(
    rng: ref HmacDrbgContext,
    capabilities: varargs[ProtocolInfo, `protocolInfo`]): EthereumNode {.gcsafe.} =
  # Don't create new RNG every time in production code!
  let keys1 = KeyPair.random(rng[])
  var bootstrapNodes: seq[ENode]
  bootstrapNodes.add ENode.fromString("enode://1cc4534b14cfe351ab740a1418ab944a234ca2f702915eadb7e558a02010cb7c5a8c295a3b56bcefa7701c07752acd5539cb13df2aab8ae2d98934d712611443@52.71.43.172:30311").get
  bootstrapNodes.add ENode.fromString("enode://28b1d16562dac280dacaaf45d54516b85bc6c994252a9825c5cc4e080d3e53446d05f63ba495ea7d44d6c316b54cd92b245c5c328c37da24605c4a93a0d099c4@34.246.65.14:30311").get
  bootstrapNodes.add ENode.fromString("enode://5a7b996048d1b0a07683a949662c87c09b55247ce774aeee10bb886892e586e3c604564393292e38ef43c023ee9981e1f8b335766ec4f0f256e57f8640b079d5@35.73.137.11:30311").get
  result = newEthereumNode(keys1, localAddress(nextPort), NetworkId(56), 
    addAllCapabilities = false, bootstrapNodes=bootstrapNodes,
    bindUdpPort = Port(nextPort), bindTcpPort = Port(nextPort),
    rng = rng)
  for capability in capabilities:
    result.addCapability capability


let rng = newRng()

var node = setupTestNode(rng, eth)
node.startListening()
let res = waitFor node.rlpxConnect(newNode "enode://1cc4534b14cfe351ab740a1418ab944a234ca2f702915eadb7e558a02010cb7c5a8c295a3b56bcefa7701c07752acd5539cb13df2aab8ae2d98934d712611443@52.71.43.172:30311")
if res.isErr():
    quit 1
else:
    var peer = res.get()
    var (msgid, msgData) = waitFor peer.recvMsg()
    echo msgData