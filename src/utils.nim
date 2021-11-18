import streams
import winregistry

proc getFileArch*(file: string): uint16 =
    let file = newFileStream(file, fmRead)
    defer: file.close()
    file.setPosition(0x3c)
    var offset: uint32
    file.read(offset)
    file.setPosition(int(offset+4))
    var machine: uint16
    file.read(machine)
    result = machine

proc isFirstRun*(): bool =
    var handle: RegHandle
    defer: handle.close()
    try:
        handle = open(HKEY_CURRENT_USER, r"Software\IDAChooser", samQueryValue)
        
    except RegistryError:
        result = true
    

proc getIDAPath*(): string =
    let handle = open(HKEY_CURRENT_USER, r"Software\IDAChooser", samRead)
    defer: handle.close()
    result = handle.readString("Path")

proc setIDAPath*(path: string): void =
    let handle = create(HKEY_CURRENT_USER,r"Software\IDAChooser",samAll)
    defer: handle.close()
    handle.writeString("Path",path)

template print*(s: varargs[string, `$`]) =
  for x in s:
    stdout.write x