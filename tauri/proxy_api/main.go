package main

import (
	"context"
	"database/sql"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	// "github.com/joho/godotenv"
	"github.com/golang-jwt/jwt"
	"github.com/jmoiron/sqlx"
	"github.com/plaid/plaid-go/v25/plaid"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"

	_ "github.com/lib/pq"
)

// Options for the CLI. Pass `--port` or set the `SERVICE_PORT` env var.
type Options struct {
	Port int `help:"Port to listen on" short:"p" default:"4000"`
}

type RequestBody struct {
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

const DATABASE_URL = "user=postgres.tqonkxhrucymdyndpjzf password=I07R6V4POCTi5wd4 host=aws-0-us-east-1.pooler.supabase.com port=6543 dbname=postgres"

const SUPABASE_JWT_SECRET = "09sUFObcLZHvtRvj5LBqtQomVPuVqOAa/LW2hcdQqyxCwpH9JDOGPwmn6XHMpaxqUPfRWkxTgiB9i4rb1Vwxwg=="

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

type User struct {
	ID    string `db:"id"`
	Email string `db:"email"`
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

	db, err := sqlx.Connect("postgres", DATABASE_URL)
	if err != nil {
		log.Fatalln(err)
	}

	db.MustExec(SYNC_STATUS_TABLE)

	plaidClient := plaid.NewAPIClient(configuration)

	e := echo.New()
	e.Use(middleware.Logger())

	e.GET("/internal/sync/status", func(c echo.Context) error {
		token, err := jwt.Parse("eyJhbGciOiJIUzI1NiIsImtpZCI6IlFtdEZUekozSEd4T3ZzL1giLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzE3MzU5NDkzLCJpYXQiOjE3MTcyNzMwOTMsImlzcyI6Imh0dHBzOi8vdHFvbmt4aHJ1Y3ltZHluZHBqemYuc3VwYWJhc2UuY28vYXV0aC92MSIsInN1YiI6IjNiOTI0ZjM2LTk0ODEtNGVmOC1iNWVlLTM2OGJkYjIyNmUxNCIsImVtYWlsIjoiZGFuZ2dnZGVubmlzQGdtYWlsLmNvbSIsInBob25lIjoiIiwiYXBwX21ldGFkYXRhIjp7InByb3ZpZGVyIjoiZW1haWwiLCJwcm92aWRlcnMiOlsiZW1haWwiXX0sInVzZXJfbWV0YWRhdGEiOnt9LCJyb2xlIjoiYXV0aGVudGljYXRlZCIsImFhbCI6ImFhbDEiLCJhbXIiOlt7Im1ldGhvZCI6Im90cCIsInRpbWVzdGFtcCI6MTcxNzI3MzA5M31dLCJzZXNzaW9uX2lkIjoiMmJjZGY1NmUtNDkyYy00OGNmLTgxYmMtNGMxYmEwOWU4MzgzIiwiaXNfYW5vbnltb3VzIjpmYWxzZX0.myfAyjddlcIe_RtwYVzf0jYXvfehC7b_AVa0Rzn1IRI&expires_at=1717359493&expires_in=86400&refresh_token=UIQFTV-fSMT0IvWgySutkQ&token_type=bearer&type=magiclink", func(token *jwt.Token) (interface{}, error) {
			// Validate the algorithm used to sign the token matches the expected algorithm
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
			}
			return SUPABASE_JWT_SECRET, nil
		})

		fmt.Println(token)

		email := token.Claims.(jwt.MapClaims)["email"]

		fmt.Println("email", email)

		user := User{}
		err = db.Get(&user, "SELECT id, email FROM auth.users WHERE email=$1", email)
		if err != nil {
			if err == sql.ErrNoRows {
				return c.JSON(http.StatusNotFound,
					map[string]string{"error": "User not found"},
				)
			}
			log.Println(err)
			return c.JSON(http.StatusBadRequest,
				map[string]string{"error": "Failed to fetch user"},
			)
		}

		fmt.Println("User: ", user)

		syncStatus := SyncStatus{}
		err = db.Get(&syncStatus, "SELECT user_id, sync_seq, last_sync FROM sync_statuses WHERE user_id=$1", user.ID)
		if err != nil {
			if err == sql.ErrNoRows {
				db.Exec("INSERT INTO sync_statuses (user_id, sync_seq, last_sync) VALUES ($1, 0, $2)", user.ID, time.Now())

				return c.JSON(http.StatusNotFound,
					map[string]string{"error": "Sync status not found"},
				)
			} else {
				log.Println(err)
				return c.JSON(http.StatusBadRequest,
					map[string]string{"error": "Failed to fetch sync status"},
				)
			}
		}

		syncStatusDto := SyncStatusDto{
			UserID:   syncStatus.UserID,
			SyncSeq:  syncStatus.SyncSeq,
			LastSync: syncStatus.LastSync,
		}

		fmt.Printf("%#v\n", syncStatusDto)

		return c.JSON(200, syncStatusDto)
	})

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
