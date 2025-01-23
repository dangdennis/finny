package controllers

import (
	"net/http"

	"github.com/finny/finny-backend/internal/ynab_auth"
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

func (y *YNABController) SomeRouteHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello, World!"))
}

func (y *YNABController) InitiateOAuth(w http.ResponseWriter, r *http.Request) {
	authURL, err := y.ynabOAuthService.InitiateOAuth(y.ynabClientID, y.ynabRedirectURI)
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
