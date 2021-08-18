package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func main() {
	if IsFirstRun() {
		fmt.Print("Path to IDA folder: ")
		var path string
		fmt.Scanln(&path)
		path = strings.TrimSpace(path)
		SetIDAPath(path)
	}

	ida_path := GetIDAPath()

	if GetArch() == 0x8664 {
		ida_path += `\ida64.exe `
	} else {
		ida_path += `\ida.exe `
	}

	exec.Command(ida_path, os.Args[1])

}
