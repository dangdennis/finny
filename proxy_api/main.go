package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/jmoiron/sqlx"
	"github.com/joho/godotenv"
	echojwt "github.com/labstack/echo-jwt/v4"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	_ "github.com/lib/pq"
	"github.com/plaid/plaid-go/v25/plaid"
)

// Options for the CLI. Pass `--port` or set the `SERVICE_PORT` env var.
type Options struct {
	Port int `help:"Port to listen on" short:"p" default:"4000"`
}

type PlaidAccessTokenRequestBody struct {
	AccessToken string `json:"access_token"`
}

const SYNC_STATUS_TABLE = `
CREATE TABLE IF NOT EXISTS sync_statuses (
    user_id uuid REFERENCES auth.users(id) PRIMARY KEY,
    sync_seq int not null default 0,
    last_sync timestamp
);

CREATE INDEX IF NOT EXISTS "ix:sync_statuses.id" ON sync_statuses(user_id uuid_ops);
`

type SyncStatus struct {
	UserID   string    `db:"user_id"`
	SyncSeq  int32     `db:"sync_seq"`
	LastSync time.Time `db:"last_sync"`
}

type SyncStatusDto struct {
	UserID   string    `json:"user_id"`
	SyncSeq  int32     `json:"sync_seq" `
	LastSync time.Time `json:"last_sync"`
}

func main() {
	port := flag.Int("p", 8080, "Port to listen on")
	flag.Parse()

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

	db, err := sqlx.Connect("postgres", databaseURL)
	if err != nil {
		log.Fatalln(err)
	}

	db.MustExec(SYNC_STATUS_TABLE)

	plaidClient := plaid.NewAPIClient(configuration)

	e := echo.New()
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	e.Use(echojwt.WithConfig(echojwt.Config{
		SigningKey: []byte(supabaseJWTSecret),
	}))

	e.GET("/internal/sync/status", func(c echo.Context) error {
		user, err := GetUserFromCtx(c, db)
		if err != nil {
			log.Println(err)
			return c.JSON(http.StatusBadRequest,
				map[string]string{"error": "Failed to fetch user"},
			)
		}

		syncStatus, err := GetSyncStatus(user, db)
		if err != nil {
			return c.JSON(http.StatusBadRequest,
				map[string]string{"error": "Failed to fetch sync status"},
			)
		}

		syncStatusDto := SyncStatusDto{
			UserID:   syncStatus.UserID,
			SyncSeq:  syncStatus.SyncSeq,
			LastSync: syncStatus.LastSync,
		}

		fmt.Printf("%#v\n", syncStatusDto)

		return c.JSON(200, syncStatusDto)
	})

	e.POST("/proxy/transactions/sync", func(c echo.Context) error {
		user, err := GetUserFromCtx(c, db)
		if err != nil {
			log.Println(err)
			return c.JSON(http.StatusBadRequest,
				map[string]string{"error": "Failed to fetch user"},
			)
		}

		reqBody := PlaidAccessTokenRequestBody{}
		if err := c.Bind(&reqBody); err != nil {
			return c.JSON(http.StatusBadRequest, map[string]string{"error": "Invalid request body"})
		}

		err = IncrementSyncStatus(user, db)
		if err != nil {
			return c.JSON(http.StatusInternalServerError,
				map[string]string{"error": "Failed to increment sync status"},
			)
		}

		request := plaid.NewTransactionsSyncRequest(
			reqBody.AccessToken,
		)

		transactions, _, err := plaidClient.PlaidApi.
			TransactionsSync(c.Request().Context()).
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

	e.POST("/proxy/accounts/get", func(c echo.Context) error {
		reqBody := PlaidAccessTokenRequestBody{}
		if err := c.Bind(&reqBody); err != nil {
			return c.JSON(http.StatusBadRequest, map[string]string{"error": "Invalid request body"})
		}

		request := plaid.NewAccountsGetRequest(
			reqBody.AccessToken,
		)

		accounts, _, err := plaidClient.PlaidApi.
			AccountsGet(c.Request().Context()).
			AccountsGetRequest(*request).
			Execute()
		if err != nil {
			log.Println(err)
			return c.JSON(http.StatusInternalServerError,
				map[string]string{"error": "Failed to fetch accounts"},
			)
		}

		return c.JSON(200, accounts)
	})

	e.Logger.Fatal(e.Start(fmt.Sprintf("0.0.0.0:%d", *port)))
}
