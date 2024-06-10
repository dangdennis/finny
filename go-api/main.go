package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/finny/backend/prisma/db"
	"github.com/joho/godotenv"
	"github.com/plaid/plaid-go/v25/plaid"

	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humaecho"
	_ "github.com/danielgtaylor/huma/v2/formats/cbor"
	"github.com/danielgtaylor/huma/v2/humacli"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

// Options for the CLI. Pass `--port` or set the `SERVICE_PORT` env var.
type Options struct {
	Port int `help:"Port to listen on" short:"p" default:"4000"`
}

type PlaidAccessTokenRequestBody struct {
	AccessToken string  `json:"access_token"`
	Count       *int32  `json:"count"`
	Cursor      *string `json:"cursor"`
}

type PlaidLinkCreateOutput struct {
	Body struct {
		LinkToken string `json:"link_token"`
	}
}

type PlaidItemCreateOutput struct {
	Body struct {
		PlaidItemID string `json:"plaid_item_id"`
	}
}

func main() {
	appEnv := os.Getenv("APP_ENV")
	if appEnv == "" || appEnv == "development" {
		err := godotenv.Load(".env")
		if err != nil {
			log.Fatal("Error loading .env file")
		}
	}

	databaseURL := os.Getenv("DATABASE_URL")
	if databaseURL == "" {
		log.Fatal("DATABASE_URL env var is required")
	}

	supabaseJWTSecret := os.Getenv("SUPABASE_JWT_SECRET")
	if supabaseJWTSecret == "" {
		log.Fatal("SUPABASE_JWT_SECRET env var is required")
	}

	plaidCreds, err := GetPlaidCreds()
	if err != nil {
		log.Fatal("Error creating Plaid client: ", err)
	}

	configuration := plaid.NewConfiguration()
	configuration.AddDefaultHeader("PLAID-CLIENT-ID", plaidCreds.ClientID)
	configuration.AddDefaultHeader("PLAID-SECRET", plaidCreds.Secret)
	configuration.UseEnvironment(plaidCreds.Env)
	plaidClient := plaid.NewAPIClient(configuration)

	prisma := db.NewClient()
	if err := prisma.Prisma.Connect(); err != nil {
		panic(err)
	}

	defer func() {
		if err := prisma.Prisma.Disconnect(); err != nil {
			panic(err)
		}
	}()

	cli := humacli.New(func(hooks humacli.Hooks, options *Options) {
		e := echo.New()
		e.Use(middleware.Logger())
		api := humaecho.New(e, huma.DefaultConfig("My API", "1.0.0"))

		huma.Register(api, huma.Operation{
			OperationID: "link-item",
			Method:      http.MethodPost,
			Path:        "/api/plaid-items/create",
			Summary:     "Link a Plaid item",
		}, func(ctx context.Context, input *struct {
			Body struct {
				PublicToken   string `json:"publicToken"`
				InstitutionID string `json:"institutionID"`
			}
		}) (*PlaidItemCreateOutput, error) {
			resp := &PlaidItemCreateOutput{}

			fmt.Println("public token input", input.Body.PublicToken)

			exchangePublicTokenReq := plaid.NewItemPublicTokenExchangeRequest(input.Body.PublicToken)
			exchangePublicTokenResp, net, err := plaidClient.PlaidApi.ItemPublicTokenExchange(ctx).ItemPublicTokenExchangeRequest(
				*exchangePublicTokenReq,
			).Execute()
			if err != nil {
				fmt.Println(net)
				fmt.Println(err)
				return nil, huma.Error404NotFound("thing not found")
			}

			itemDb, err := prisma.PlaidItems.CreateOne(
				db.PlaidItems.PlaidAccessToken.Set(exchangePublicTokenResp.GetAccessToken()),
				db.PlaidItems.PlaidItemID.Set(exchangePublicTokenResp.GetItemId()),
				db.PlaidItems.PlaidInstitutionID.Set("soomething"),
				db.PlaidItems.Status.Set("good"),
				db.PlaidItems.Users.Link(
					db.Users.ID.Equals("2be19323-7a1d-4504-8de9-70f06e90f66f"),
				),
			).Exec(ctx)

			go func(itemId string, plaidClient *plaid.APIClient) {
				ctx := context.Background()

				itemDb, err := prisma.PlaidItems.FindFirst(
					db.PlaidItems.ID.Equals(itemId),
				).Exec(ctx)
				if err != nil {
					log.Println(err)
					return
				}

				request := plaid.NewTransactionsSyncRequest(
					itemDb.PlaidAccessToken,
				)
				transactionsResp, _, err := plaidClient.PlaidApi.TransactionsSync(ctx).TransactionsSyncRequest(*request).Execute()
				if err != nil {
					log.Println(err)
					return
				}

				for _, account := range transactionsResp.GetAccounts() {
					_, err := prisma.Accounts.CreateOne(
						db.Accounts.PlaidAccountID.Set(account.AccountId),
						db.Accounts.Name.Set(account.Name),
						db.Accounts.PlaidItems.Link(
							db.PlaidItems.ID.Equals(itemDb.ID),
						),
						db.Accounts.Users.Link(
							db.Users.ID.Equals("2be19323-7a1d-4504-8de9-70f06e90f66f"),
						),
						db.Accounts.Name.Set(account.Name),
						db.Accounts.OfficialName.SetIfPresent(account.OfficialName.Get()),
						db.Accounts.Mask.SetIfPresent(account.Mask.Get()),
						db.Accounts.CurrentBalance.SetIfPresent(account.Balances.Current.Get()),
						db.Accounts.AvailableBalance.SetIfPresent(account.Balances.Available.Get()),
						db.Accounts.IsoCurrencyCode.SetIfPresent(account.Balances.IsoCurrencyCode.Get()),
						db.Accounts.UnofficialCurrencyCode.SetIfPresent(account.Balances.UnofficialCurrencyCode.Get()),
						db.Accounts.Type.Set(string(account.GetType())),
						db.Accounts.Subtype.Set(string(account.GetSubtype())),
					).Exec(ctx)
					if err != nil {
						log.Println(err)
						continue
					}
				}

				// for _, transaction := range transactionsResp.GetAdded() {
				// 	prisma.Transactions.CreateOne(
				// 		db.Transactions.AccountID.Set(transaction.AccountId),
				// 		db.Transactions.PlaidTransactionID.Set(transaction.TransactionId),
				// 		db.Transactions.Category.Set(transaction.GetPersonalFinanceCategory().Primary)),
				// 		db.Transactions.Subcategory.Set(transaction.GetPersonalFinanceCategory().Secondary)),

				// 	).Exec(ctx)
				// }

			}(itemDb.ID, plaidClient)

			resp.Body.PlaidItemID = itemDb.PlaidItemID

			return resp, nil
		})

		huma.Register(api, huma.Operation{
			OperationID: "new-link-token",
			Method:      http.MethodPost,
			Path:        "/api/plaid-link/create",
			Summary:     "Create a new Link token",
		}, func(ctx context.Context, input *struct {
			PublicToken   string `path:"public_token"`
			InstitutionID string `path:"institution_id"`
		}) (*PlaidLinkCreateOutput, error) {
			resp := &PlaidLinkCreateOutput{}

			user := plaid.LinkTokenCreateRequestUser{
				ClientUserId: "some-user-id",
			}
			request := plaid.NewLinkTokenCreateRequest(
				"Finny",
				"en",
				[]plaid.CountryCode{plaid.COUNTRYCODE_US},
				user,
			)
			// request.SetProducts([]plaid.Products{plaid.PRODUCTS_AUTH})
			// request.SetLinkCustomizationName("default")
			// request.SetWebhook("https://webhook-uri.com")
			// request.SetRedirectUri("https://domainname.com/oauth-page.html")
			// request.SetAccountFilters(plaid.LinkTokenAccountFilters{
			// 	Depository: &plaid.DepositoryFilter{
			// 		AccountSubtypes:
			// 	},
			// })
			linkTokenRes, _, err := plaidClient.PlaidApi.LinkTokenCreate(ctx).LinkTokenCreateRequest(*request).Execute()
			if err != nil {
				return nil, huma.Error404NotFound("thing not found")
			}

			resp.Body.LinkToken = linkTokenRes.GetLinkToken()

			return resp, nil
		})

		fmt.Printf("Server listening on port http://localhost:%d", options.Port)
		e.Logger.Fatal(e.Start(fmt.Sprintf("0.0.0.0:%d", options.Port)))
	})

	cli.Run()
}
