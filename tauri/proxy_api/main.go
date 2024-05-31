package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"

	// "github.com/joho/godotenv"
	"github.com/plaid/plaid-go/v25/plaid"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

// Options for the CLI. Pass `--port` or set the `SERVICE_PORT` env var.
type Options struct {
	Port int `help:"Port to listen on" short:"p" default:"8080"`
}

type RequestBody struct {
	AccessToken string `json:"access_token"`
}

func main() {
	port := flag.Int("p", 8080, "Port to listen on")
	flag.Parse()
	// err := godotenv.Load()
	// if err != nil {
	// 	log.Fatal("Error loading .env file")
	// }

	// plaidClientID := os.Getenv("PLAID_CLIENT_ID")
	// plaidEnv := os.Getenv("PLAID_ENV")
	plaidClientID := "661ac9375307a3001ba2ea46"
	plaidEnv := "sandbox"

	var plaidSecretString string
	switch plaidEnv {
	case "sandbox":
		// plaidSecretString = os.Getenv("PLAID_SECRET_SANDBOX")
		plaidSecretString = "57ebac97c0bcf92f35878135d68793"
	case "development":
		plaidSecretString = os.Getenv("PLAID_SECRET_DEVELOPMENT")
	case "production":
		plaidSecretString = os.Getenv("PLAID_SECRET_PRODUCTION")
	}
	if len(plaidClientID) == 0 || len(plaidSecretString) == 0 {
		log.Fatal("Plaid credentials not set")
	}

	configuration := plaid.NewConfiguration()
	configuration.AddDefaultHeader("PLAID-CLIENT-ID", plaidClientID)
	configuration.AddDefaultHeader("PLAID-SECRET", plaidSecretString)
	configuration.UseEnvironment(plaid.Sandbox)
	plaidClient := plaid.NewAPIClient(configuration)

	e := echo.New()
	e.Use(middleware.Logger())

	e.POST("/transactions/sync", func(c echo.Context) error {
		ctx := context.Background()

		reqBody := new(RequestBody)
		if err := c.Bind(reqBody); err != nil {
			return c.JSON(http.StatusBadRequest, map[string]string{"error": "Invalid request body"})
		}

		request := plaid.NewTransactionsSyncRequest(
			reqBody.AccessToken,
		)

		transactions, _, err := plaidClient.PlaidApi.
			TransactionsSync(ctx).
			TransactionsSyncRequest(*request).
			Execute()
		if err != nil {
			log.Println(err)
			return c.JSON(http.StatusInternalServerError,
				map[string]string{"error": "Failed to fetch transactions"},
			)
		}

		return c.JSON(200, transactions)
	})

	e.Logger.Fatal(e.Start(fmt.Sprintf("0.0.0.0:%d", *port)))
}
