
{.used, push raises: [].}

import
  eth/p2p,
  ../../core/[chain, tx_pool],
  ../protocol,
  ./eth as handlers_eth


proc setEthHandlerNewBlocksAndHashes*(node: var EthereumNode; blockHandler: NewBlockHandler; hashesHandler: NewBlockHashesHandler; arg: pointer; ) {.gcsafe, raises: [CatchableError].} =
  let w = EthWireRef(node.protocolState protocol.eth)
  w.setNewBlockHandler(blockHandler, arg)
  w.setNewBlockHashesHandler(hashesHandler, arg)

proc addEthHandlerCapability*(node: var EthereumNode;peerPool: PeerPool;chain: ChainRef;txPool = TxPoolRef(nil);) =
  node.addCapability(protocol.eth, EthWireRef.new(chain, txPool, peerPool))


