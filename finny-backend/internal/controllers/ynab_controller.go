package controllers

import (
	"net/http"

	"github.com/finny/finny-backend/internal/ynab_auth"
	"github.com/labstack/echo/v4"
)

type YNABController struct {
	// todo(rani): ynabOAuthService *ynab_auth.YNABAuthServiceIntf some kind of interface should replace the type `*ynab_auth.YNABAuthService`
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
	authURL, err := y.ynabOAuthService.InitiateOAuth(y.ynabClientID, y.ynabRedirectURI)
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

	_, err := y.ynabOAuthService.ExchangeCodeForTokens(code)
	if err != nil {
		return c.String(http.StatusInternalServerError, "Failed to exchange code for tokens")
	}

	return c.JSON(http.StatusOK, map[string]string{
		"message": "Successfully authenticated with YNAB!",
	})
}
