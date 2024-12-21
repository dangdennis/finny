package main

import (
	"fmt"
	"os"

	"github.com/finny/finny-backend/bin/server"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("expected 'serve' subcommand")
		os.Exit(1)
	}

	switch os.Args[1] {
	case "serve":
		server.StartServer()
	default:
		fmt.Printf("unknown command: %s\n", os.Args[1])
		fmt.Println("expected 'serve' or 'migrate' subcommands")
		os.Exit(1)
	}
}
