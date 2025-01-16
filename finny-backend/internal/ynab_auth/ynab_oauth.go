package ynab_auth

import (
	"crypto/rand"
	"encoding/base64"
	"net/url"
	"os"
)

type YNABAuthService struct {
}

func NewYNABAuthService() *YNABAuthService {
	return &YNABAuthService{}
}

func (y *YNABAuthService) GenerateState() (string, error) {
	b := make([]byte, 32)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return base64.URLEncoding.EncodeToString(b), nil
}

func (y *YNABAuthService) GetAuthorizationURL(state string) string {
    clientID := os.Getenv("YNAB_CLIENT_ID")
    redirectURI := os.Getenv("YNAB_REDIRECT_URI")

    return "https://app.ynab.com/oauth/authorize?" +
        "client_id=" + url.QueryEscape(clientID) +
        "&redirect_uri=" + url.QueryEscape(redirectURI) +
        "&response_type=code" +
        "&state=" + url.QueryEscape(state)
}
