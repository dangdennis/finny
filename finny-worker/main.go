package main

import (
	"log"
	"net/http"
	"os"

	"github.com/finny/worker/account"
	"github.com/finny/worker/budget"
	"github.com/finny/worker/database"
	"github.com/finny/worker/finalytics"
	"github.com/finny/worker/goal"
	"github.com/finny/worker/profile"
	"github.com/finny/worker/transaction"

	"github.com/joho/godotenv"
)

func main() {
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

	accountRepo := account.NewAccountRepository(db)
	transactionRepo := transaction.NewTransactionRepository(db)
	goalRepo := goal.NewGoalRepository(db, accountRepo)
	profileRepo := profile.NewProfileRepository(db)
	_ = finalytics.NewFinalyticsService(db, profileRepo, goalRepo, transactionRepo)
	_ = budget.NewBudgetService(db)

	http.HandleFunc("POST /start", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Worker started"))
	})

	log.Println("Worker is ready to start on demand")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
