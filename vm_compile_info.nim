func vmName(): string =
  when defined(evmc_enabled):
    "evmc"
  else:
    "nimvm"

const
  VmName* = vmName()
  warningMsg = block:
    var rc = "*** Compiling with " & VmName
    when defined(legacy_eth66_enabled):
      rc &= ", legacy-eth/66"
    when defined(chunked_rlpx_enabled):
      rc &= ", chunked-rlpx"
    when defined(boehmgc):
      rc &= ", boehm/gc"
    rc &= " enabled"
    rc

{.warning: warningMsg.}

{.used.}
