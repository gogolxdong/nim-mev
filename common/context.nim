import
  std/[strutils, os],
  manager,
  stew/[results, io2, byteutils],
  eth/keys

export manager

{.push raises: [].}

type
  EthContext* = ref object
    am*: AccountsManager
    rng*: ref HmacDrbgContext

proc newEthContext*(): EthContext =
  result = new(EthContext)
  result.am = AccountsManager.init()
  result.rng = newRng()

proc randomPrivateKey*(ctx: EthContext): PrivateKey =
  random(PrivateKey, ctx.rng[])

proc randomKeyPair*(ctx: EthContext): KeyPair =
  random(KeyPair, ctx.rng[])

proc containsOnlyHexDigits(hex: string): bool =
  const HexDigitsX = HexDigits + {'x'}
  for c in hex:
    if c notin HexDigitsX:
      return false
  true

proc getNetKeys*(ctx: EthContext, netKey, dataDir: string): Result[KeyPair, string]
    {.gcsafe, raises: [OSError]} =
  if netKey.len == 0 or netKey == "random":
    let privateKey = ctx.randomPrivateKey()
    return ok(privateKey.toKeyPair())
  elif netKey.len in {64, 66} and netKey.containsOnlyHexDigits:
    let res = PrivateKey.fromHex(netKey)
    if res.isErr:
      return err($res.error)
    return ok(res.get().toKeyPair())
  else:
    if fileAccessible(netKey, {AccessFlags.Find}):
      try:
        let lines = netKey.readLines(1)
        if lines.len == 0:
          return err("empty network key file")
        let rc = PrivateKey.fromHex(lines[0])
        if rc.isErr:
          return err($rc.error)
        return ok(rc.get().toKeyPair())
      except IOError as e:
        return err("cannot open network key file: " & e.msg)
      except ValueError as ex:
        return err("invalid hex string in network key file: " & ex.msg)
    else:
      let privateKey = ctx.randomPrivateKey()

      try:
        createDir(netKey.splitFile.dir)
        netKey.writeFile(privateKey.toRaw.to0xHex)
      except IOError as e:
        return err("could not write network key file: " & e.msg)

      return ok(privateKey.toKeyPair())
