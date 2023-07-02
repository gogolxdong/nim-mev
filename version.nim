import strutils

const
  NimbusName* = "nimbus-eth1"

  NimbusMajor*: int = 0

  NimbusMinor*: int = 1

  NimbusPatch*: int = 0

  NimbusVersion* = $NimbusMajor & "." & $NimbusMinor & "." & $NimbusPatch

  GitRevision* = strip(staticExec("git rev-parse --short HEAD"))[0..5]

  NimVersion* = staticExec("nim --version | grep Version")

