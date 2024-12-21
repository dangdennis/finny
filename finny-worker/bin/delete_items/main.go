package main

import (
	"context"
	"errors"
	"fmt"

	"github.com/finny/worker/database"
	"github.com/finny/worker/plaid_item"
	"github.com/plaid/plaid-go/plaid"
)

func main() {
	// query all plaid items
	// delete all plaid items from plaid api

	db, err := database.NewDatabase("")
	if err != nil {
		panic(err)
	}

	var plaidItems []plaid_item.PlaidItem
	err = db.Find(&plaidItems).Error
	if err != nil {
		panic(err)
	}

	if len(plaidItems) == 0 {
		panic(errors.New("no plaid items found"))
	}

	// fmt.Printf("%+v\n", plaidItems)

	configuration := plaid.NewConfiguration()
	configuration.AddDefaultHeader("PLAID-CLIENT-ID", "x")
	configuration.AddDefaultHeader("PLAID-SECRET", "y")
	configuration.UseEnvironment(plaid.Production)
	client := plaid.NewAPIClient(configuration)

	for _, plaidItem := range plaidItems {
		plaidHttpResponse, _, err := client.PlaidApi.ItemRemove(context.Background()).ItemRemoveRequest(plaid.ItemRemoveRequest{
			AccessToken: plaidItem.PlaidAccessToken,
		}).Execute()
		if err != nil {
			fmt.Printf("failed to remove plaid item %s %+v\n", plaidItem.PlaidItemID, err)
		}

		fmt.Printf("removed plaid item %s %+v\n", plaidItem.PlaidItemID, plaidHttpResponse)
	}

}
