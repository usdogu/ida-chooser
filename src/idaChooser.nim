import os, strutils, osproc
import ./utils

let first_param = paramStr(1)

if isFirstRun():
  print("Path to IDA folder: ")
  var path = readLine(stdin)
  path.stripLineEnd()
  setIDAPath(path)

var ida_path = getIDAPath()
if getFileArch(first_param) == 0x8664:
  ida_path.add(r"\ida64.exe")
else:
  ida_path.add(r"\ida.exe")

discard startProcess(ida_path,args=[first_param])
