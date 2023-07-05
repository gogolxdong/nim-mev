
when defined(legacy_eth66_enabled):
  import ./protocol/eth66 as proto_eth
  type eth* = eth66
else:
  import ./protocol/eth67 as proto_eth
  type eth* = eth67

export proto_eth

