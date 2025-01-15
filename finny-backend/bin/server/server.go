package server

import (
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

	databaseUrl := os.Getenv("DATABASE_URL")
	if databaseUrl == "" {
		log.Fatal("DATABASE_URL is not set")
	}

	db, err := database.NewDatabase(databaseUrl)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	budgetService := budget.NewBudgetService(db)
	ynabAuthService := ynab_auth.NewYNABAuthService()

	budgetController := controllers.NewBudgetController(budgetService)
	ynabOAuthController := controllers.NewYNABController(ynabAuthService)

	http.HandleFunc("POST /api/get-expense", func(w http.ResponseWriter, r *http.Request) {
		budgetController.GetExpense(w, r)
	})

	http.HandleFunc("POST /api/oauth/ynab/whatever", func(w http.ResponseWriter, r *http.Request) {
		ynabOAuthController.SomeRouteHandler(w, r)
	})

	log.Println("Finny server is listening on port 8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
