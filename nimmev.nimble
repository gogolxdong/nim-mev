mode = ScriptMode.Verbose

packageName   = "nimmev"
version       = "0.1.0"
author        = "Sheldon"
description   = "An Ethereum 2.0 Sharding Client for Resource-Restricted Devices"
license       = "Apache License 2.0"
skipDirs      = @["tests", "examples"]

requires "nim >= 1.2.0",
  "bncurve",
  "chronicles",
  "chronos",
  "https://github.com/gogolxdong/nim-eth",
  "json_rpc",
  "libbacktrace",
  "nimcrypto",
  "stew",
  "stint",
  "ethash",
  "blscurve",
  "evmc",
  "https://github.com/gogolxdong/nim-web3"

binDir = "build"