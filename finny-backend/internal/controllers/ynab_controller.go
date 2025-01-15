package controllers

import (
	"net/http"

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
