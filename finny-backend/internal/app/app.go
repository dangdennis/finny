package app

import (
	"crypto/rand"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/finny/finny-backend/internal/budget"
	"github.com/finny/finny-backend/internal/controllers"
	"github.com/finny/finny-backend/internal/database"
	"github.com/finny/finny-backend/internal/ynab_auth"

	"github.com/joho/godotenv"
	echojwt "github.com/labstack/echo-jwt/v4"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

type Config struct {
	YNABClientID    string
	YNABRedirectURI string
	DatabaseURL     string
	JWTSecret       []byte
}

type App struct {
	config           Config
	budgetController *controllers.BudgetController
	ynabController   *controllers.YNABController
}

func loadConfig() (Config, error) {
	err := godotenv.Load(".env")
	if err != nil {
		log.Println("Error loading .env file:", err)
	} else {
		log.Println(".env file loaded successfully")
	}

	config := Config{
		YNABClientID:    os.Getenv("YNAB_CLIENT_ID"),
		YNABRedirectURI: os.Getenv("YNAB_REDIRECT_URI"),
		DatabaseURL:     os.Getenv("DATABASE_URL"),
		JWTSecret:       []byte(os.Getenv("SUPABASE_JWT")),
	}

	if config.YNABClientID == "" {
		return config, fmt.Errorf("YNAB_CLIENT_ID is not set")
	}
	if config.YNABRedirectURI == "" {
		return config, fmt.Errorf("YNAB_REDIRECT_URI is not set")
	}
	if config.DatabaseURL == "" {
		return config, fmt.Errorf("DATABASE_URL is not set")
	}
	if len(config.JWTSecret) == 0 {
		return config, fmt.Errorf("SUPABASE_JWT is not set")
	}

	return config, nil
}

func NewApp(config Config) (*App, error) {
	db, err := database.NewDatabase(config.DatabaseURL)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to database: %v", err)
	}

	ynabAuthService, err := ynab_auth.NewYNABAuthService(rand.Reader, db)
	if err != nil {
		return nil, fmt.Errorf("failed to create YNAB auth service: %v", err)
	}
	budgetService, err := budget.NewBudgetService(db, ynabAuthService)
	if err != nil {
		return nil, fmt.Errorf("failed to create budget service: %v", err)
	}

	budgetController := controllers.NewBudgetController(budgetService)
	ynabController := controllers.NewYNABController(ynabAuthService, config.YNABClientID, config.YNABRedirectURI)

	// Background task to clean up expired oauth states.
	go func() {
		fmt.Println("Starting cleanup task of oauth states...")
		ticker := time.NewTicker(1 * time.Minute)
		defer ticker.Stop()

		backoff := time.Second // Initial backoff duration
		maxBackoff := 5 * time.Minute

		for {
			select {
			case <-ticker.C:
				err := ynabAuthService.CleanupExpiredStates(10 * time.Minute)
				if err != nil {
					log.Printf("Error cleaning up expired states: %v. Retrying in %v...", err, backoff)

					// Wait for backoff duration before retrying
					time.Sleep(backoff)

					// Exponential backoff with a maximum limit
					backoff *= 2
					if backoff > maxBackoff {
						backoff = maxBackoff
					}

					continue
				}
				// Reset backoff on successful cleanup
				backoff = time.Second
			}
		}
	}()

	return &App{
		config:           config,
		budgetController: budgetController,
		ynabController:   ynabController,
	}, nil
}

func (a *App) SetupRoutes(e *echo.Echo) {
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	e.Use(middleware.CORS())

	jwtConfig := echojwt.Config{
		SigningKey: a.config.JWTSecret,
	}

	// API routes (protected)
	api := e.Group("/api")
	api.Use(echojwt.WithConfig(jwtConfig))
	api.POST("/expenses/get-expense", a.budgetController.GetExpense)
	api.GET("/ynab/auth-status", a.ynabController.GetAuthStatus)

	// OAuth routes
	oauth := e.Group("/oauth")
	oauth.GET("/ynab/authorize", a.ynabController.InitiateOAuth, echojwt.WithConfig(jwtConfig)) // Require authentication to initiate oauth
	oauth.GET("/ynab/callback", a.ynabController.HandleCallback)

	// Public routes
	e.GET("/", func(c echo.Context) error {
		return c.String(200, "Hello there")
	})
}

func Start() {
	config, err := loadConfig()
	if err != nil {
		log.Fatal(err)
	}

	app, err := NewApp(config)
	if err != nil {
		log.Fatal(err)
	}

	e := echo.New()
	app.SetupRoutes(e)

	log.Println("Finny server is listening on port 8080")
	log.Fatal(e.Start(":8080"))
}
