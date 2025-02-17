package controllers

import (
	"fmt"
	"net/http"

	"github.com/finny/finny-backend/internal/ynab_auth"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

type YNABController struct {
	ynabOAuthService *ynab_auth.YNABAuthService
	ynabClientID     string
	ynabRedirectURI  string
}

func NewYNABController(ynabOAuthService *ynab_auth.YNABAuthService, ynabClientID string, ynabRedirectURI string) *YNABController {
	return &YNABController{
		ynabOAuthService: ynabOAuthService,
		ynabClientID:     ynabClientID,
		ynabRedirectURI:  ynabRedirectURI,
	}
}

func (y *YNABController) InitiateOAuth(c echo.Context) error {
	userID, err := GetContextUserID(c)
	if err != nil {
		fmt.Printf("Failed to get user ID from context: %v\n", err)
		return c.String(http.StatusBadRequest, "User not authenticated")
	}

	authURL, err := y.ynabOAuthService.InitiateOAuth(y.ynabClientID, y.ynabRedirectURI, userID)
	if err != nil {
		return c.String(http.StatusInternalServerError, "Failed to generate state")
	}

	return c.Redirect(http.StatusTemporaryRedirect, authURL)
}

func (y *YNABController) HandleCallback(c echo.Context) error {
	code := c.QueryParam("code")
	if code == "" {
		return c.String(http.StatusBadRequest, "Missing authorization code")
	}

	userID := c.Get("user_id").(uuid.UUID)
	if userID == uuid.Nil {
		return c.String(http.StatusUnauthorized, "User not authenticated")
	}

	err := y.ynabOAuthService.ExchangeCodeForTokens(code, userID)
	if err != nil {
		return c.String(http.StatusInternalServerError, "Failed to exchange code for tokens")
	}

	// Return an HTML page with a success message
	htmlContent := `
	<!DOCTYPE html>
	<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>YNAB Connection Successful</title>
	</head>
	<body>
		<h1>Connected to YNAB!</h1>
		<p>You can close this window now.</p>
	</body>
	</html>
	`

	return c.HTML(http.StatusOK, htmlContent)
}
