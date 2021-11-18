# Package

version       = "0.1.0"
author        = "USPRO"
description   = "A Simple Program That Chooses The Right IDA For An Executable"
license       = "Unlicense"
srcDir        = "src"
namedBin["idaChooser"] = "ida-chooser"


# Dependencies

requires "nim >= 1.6.0", "winregistry == 0.2.1"
