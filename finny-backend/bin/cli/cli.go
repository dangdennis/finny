// To run: from /finny-backend, run `go run ./bin/cli/cli.go`

package main

import (
	"github.com/finny/finny-backend/internal/ynab_client"
)

func main() {
	_, err := ynab_client.NewYNABClient("xxx")
	if err != nil {
		panic(err)
	}
}
