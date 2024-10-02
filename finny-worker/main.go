package main

import (
	"log"
	"net/http"
	"os"

	"github.com/finny/worker/database"
	finalytics "github.com/finny/worker/finalytics"
	"github.com/finny/worker/plaid_items"
	"github.com/finny/worker/queue"

	"github.com/joho/godotenv"
	"github.com/labstack/echo/v4"
)

func main() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Println("Error loading .env file:", err)
	} else {
		log.Println(".env file loaded successfully")
	}

	lavinMqUrl := os.Getenv("LAVIN_MQ_URL")
	if lavinMqUrl == "" {
		log.Fatal("LAVIN_MQ_URL is not set")
	}

	databaseUrl := os.Getenv("DATABASE_URL")
	if databaseUrl == "" {
		log.Fatal("DATABASE_URL is not set")
	}

	e := echo.New()

	db, err := database.NewDatabase(databaseUrl)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	qm, err := queue.NewLavinMqQueue(lavinMqUrl)
	if err != nil {
		log.Fatalf("Failed to connect to LavinMQ: %v", err)
	}
	defer qm.Close()

	finalyticsSvc := finalytics.NewFinalyticsService(db)
	plaidItemsRepo := plaid_items.NewPlaidItemRepository(db)

	workerManager, err := finalytics.NewWorkerManager(db, qm, finalyticsSvc, plaidItemsRepo)
	if err != nil {
		log.Fatalf("Failed to open a channel: %v", err)
	}
	defer workerManager.Close()

	e.POST("/start", func(c echo.Context) error {
		workerManager.StartWorker()
		return c.String(http.StatusOK, "Worker started")
	})

	log.Println("Worker is ready to start on demand")
	e.Logger.Fatal(e.Start(":8080"))
}
