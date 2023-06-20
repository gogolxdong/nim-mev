# Copyright (c) 2018-2022 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE))
#  * MIT license ([LICENSE-MIT](LICENSE-MIT))
# at your option.
# This file may not be copied, modified, or distributed except according to
# those terms.

import strutils

const
  NimbusName* = "nimbus-eth1"

  NimbusMajor*: int = 0

  NimbusMinor*: int = 1

  NimbusPatch*: int = 0

  NimbusVersion* = $NimbusMajor & "." & $NimbusMinor & "." & $NimbusPatch

  GitRevision* = strip(staticExec("git rev-parse --short HEAD"))[0..5]

  NimVersion* = staticExec("nim --version | grep Version")

