package app

import (
	"crypto/rand"
	"log"
	"net/http"
	"os"

	"github.com/finny/finny-backend/internal/budget"
	"github.com/finny/finny-backend/internal/controllers"
	"github.com/finny/finny-backend/internal/database"
	"github.com/finny/finny-backend/internal/ynab_auth"

	"github.com/joho/godotenv"
)

func StartServer() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Println("Error loading .env file:", err)
	} else {
		log.Println(".env file loaded successfully")
	}

	ynabClientID := os.Getenv("YNAB_CLIENT_ID")
	if ynabClientID == "" {
		log.Fatal("YNAB_CLIENT_ID is not set")
	}

	ynabRedirectURI := os.Getenv("YNAB_REDIRECT_URI")
	if ynabRedirectURI == "" {
		log.Fatal("YNAB_REDIRECT_URI is not set")
	}

	databaseUrl := os.Getenv("DATABASE_URL")
	if databaseUrl == "" {
		log.Fatal("DATABASE_URL is not set")
	}

	db, err := database.NewDatabase(databaseUrl)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	budgetService := budget.NewBudgetService(db)
	ynabAuthService := ynab_auth.NewYNABAuthService(rand.Reader)

	budgetController := controllers.NewBudgetController(budgetService)
	ynabOAuthController := controllers.NewYNABController(ynabAuthService, ynabClientID, ynabRedirectURI)

	http.HandleFunc("POST /api/get-expense", func(w http.ResponseWriter, r *http.Request) {
		budgetController.GetExpense(w, r)
	})

	http.HandleFunc("POST /api/oauth/ynab/whatever", func(w http.ResponseWriter, r *http.Request) {
		ynabOAuthController.SomeRouteHandler(w, r)
	})

	// todo(rani): we want to test certain behaviors from this route
	// 1.
	http.HandleFunc("GET /api/oauth/ynab/authorize", func(w http.ResponseWriter, r *http.Request) {
		ynabOAuthController.InitiateOAuth(w, r)
	})

	http.HandleFunc("GET /api/oauth/ynab/callback", func(w http.ResponseWriter, r *http.Request) {
		ynabOAuthController.HandleCallback(w, r)
	})

	log.Println("Finny server is listening on port 8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
