package main

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func main() {
	if IsFirstRun() {
		fmt.Print("Path to IDA folder: ")
		in := bufio.NewReader(os.Stdin)
		path, _ := in.ReadString('\n')
		path = strings.TrimSpace(path)
		SetIDAPath(path)
	}

	ida_path := GetIDAPath()

	if GetArch() == 0x8664 {
		ida_path += `\ida64.exe`
	} else {
		ida_path += `\ida.exe`
	}

	cmd := exec.Command(ida_path, os.Args[1])
	cmd.Start()
}
