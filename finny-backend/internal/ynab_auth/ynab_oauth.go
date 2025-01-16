package ynab_auth

import (
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"os"
	"strings"
)

type TokenResponse struct {
	AccessToken  string `json:"access_token"`
	TokenType    string `json:"token_type"`
	ExpiresIn    int    `json:"expires_in"`
	RefreshToken string `json:"refresh_token"`
}

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

func (y *YNABAuthService) ExchangeCodeForTokens(code string) (*TokenResponse, error) {
    clientID := os.Getenv("YNAB_CLIENT_ID")
    clientSecret := os.Getenv("YNAB_CLIENT_SECRET")
    redirectURI := os.Getenv("YNAB_REDIRECT_URI")

    data := url.Values{}
    data.Set("client_id", clientID)
    data.Set("client_secret", clientSecret)
    data.Set("redirect_uri", redirectURI)
    data.Set("grant_type", "authorization_code")
    data.Set("code", code)

    resp, err := http.Post(
        "https://app.ynab.com/oauth/token",
        "application/x-www-form-urlencoded",
        strings.NewReader(data.Encode()),
    )
    if err != nil {
        return nil, fmt.Errorf("failed to exchange code: %w", err)
    }
    defer resp.Body.Close()

    var tokenResponse TokenResponse
    if err := json.NewDecoder(resp.Body).Decode(&tokenResponse); err != nil {
        return nil, fmt.Errorf("failed to decode token response: %w", err)
    }

    return &tokenResponse, nil
}
