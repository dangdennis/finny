package controllers

import (
	"net/http"
	"os"

	"github.com/finny/finny-backend/internal/ynab_auth"
)

type YNABController struct {
	ynabOAuthService *ynab_auth.YNABAuthService
}

func NewYNABController(ynabOAuthService *ynab_auth.YNABAuthService) *YNABController {
	return &YNABController{
		ynabOAuthService: ynabOAuthService,
	}
}

func (y *YNABController) SomeRouteHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello, World!"))
}

func (y *YNABController) InitiateOAuth(w http.ResponseWriter, r *http.Request) {
	clientID := os.Getenv("YNAB_CLIENT_ID")
	redirectURI := os.Getenv("YNAB_REDIRECT_URI")

	authURL, err := y.ynabOAuthService.InitiateOAuth(clientID, redirectURI)
	if err != nil {
		http.Error(w, "Failed to generate state", http.StatusInternalServerError)
		return
	}

	http.Redirect(w, r, authURL, http.StatusTemporaryRedirect)
}

func (y *YNABController) HandleCallback(w http.ResponseWriter, r *http.Request) {
	code := r.URL.Query().Get("code")
	if code == "" {
		http.Error(w, "Missing authorization code", http.StatusBadRequest)
		return
	}

	_, err := y.ynabOAuthService.ExchangeCodeForTokens(code)
	if err != nil {
		http.Error(w, "Failed to exchange code for tokens", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write([]byte(`{"message": "Successfully authenticated with YNAB!"}`))

}
