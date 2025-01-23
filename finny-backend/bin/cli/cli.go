// To run: from /finny-backend, run `go run ./bin/cli/cli.go`

package main

import (
	"fmt"

	"github.com/brunomvsouza/ynab.go"
)

func main() {
	pat := ""

	c := ynab.NewClient(pat)
	budget, err := c.Budget().GetLastUsedBudget(nil)
	if err != nil {
		panic(err)
	}

	fmt.Printf("print my entire budget %+v", *budget.Budget)

}
