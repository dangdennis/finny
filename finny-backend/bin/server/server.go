package server

import (
	"log"
	"net/http"
	"os"

	"github.com/finny/finny-backend/internal/budget"
	"github.com/finny/finny-backend/internal/database"
	"github.com/finny/finny-backend/internal/ynabclient"

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

	ynabSecret := os.Getenv("YNAB_SECRET")
	if ynabSecret == "" {
		log.Fatal("YNAB_SECRET is not set")
	}

	db, err := database.NewDatabase(databaseUrl)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	ynabClient := ynabclient.NewYNABClient(ynabSecret)
	_ = budget.NewBudgetService(db, ynabClient)

	http.HandleFunc("POST /api/get-expense", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Worker started"))
	})

	log.Println("Worker is ready to start on demand")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
