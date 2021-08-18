package main

import (
	"encoding/binary"
	"os"

	"golang.org/x/sys/windows/registry"
)

func GetArch() uint16 {
	file, _ := os.Open(os.Args[1])
	defer file.Close()
	file.Seek(0x3c, 0)
	var offset uint32
	binary.Read(file, binary.LittleEndian, &offset)
	file.Seek(int64(offset+4), 0)
	var machine uint16
	binary.Read(file, binary.LittleEndian, &machine)
	return machine
}

func GetIDAPath() string {
	k, _ := registry.OpenKey(registry.CURRENT_USER, `Software\IDAChooser`, registry.READ)
	defer k.Close()
	s, _, _ := k.GetStringValue("Path")
	return s
}

func SetIDAPath(path string) {
	k, _, _ := registry.CreateKey(registry.CURRENT_USER, `Software\IDAChooser`, registry.ALL_ACCESS)
	defer k.Close()
	k.SetStringValue("Path", path)
}

func IsFirstRun() bool {
	k, err := registry.OpenKey(registry.CURRENT_USER, `Software\IDAChooser`, registry.READ)
	if err != registry.ErrNotExist {
		k.Close()
	}
	return err == registry.ErrNotExist
}
