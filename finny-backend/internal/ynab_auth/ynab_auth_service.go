package ynab_auth

import (
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/url"
	"os"
	"strings"
	"time"

	"github.com/finny/finny-backend/internal/models"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type RandomReader interface {
	Read([]byte) (int, error)
}

type YNABAuthService struct {
	randReader RandomReader
	db         *gorm.DB
}

func NewYNABAuthService(randReader RandomReader, db *gorm.DB) (*YNABAuthService, error) {
	if randReader == nil {
		randReader = rand.Reader
	}

	if db == nil {
		return nil, fmt.Errorf("db is nil")
	}

	return &YNABAuthService{
		randReader: randReader,
		db:         db,
	}, nil
}

func (y *YNABAuthService) GenerateState(userID uuid.UUID) (string, error) {
	b := make([]byte, 32)
	if _, err := y.randReader.Read(b); err != nil {
		return "", err
	}
	stateWithUser := fmt.Sprintf("%s.%s", b, userID.String())
	return base64.URLEncoding.EncodeToString([]byte(stateWithUser)), nil
}

func (y *YNABAuthService) InitiateOAuth(clientID string, redirectURI string, userID uuid.UUID) (string, error) {
	state, err := y.GenerateState(userID)
	if err != nil {
		return "", err
	}

	authURL := y.GetAuthorizationURL(state, clientID, redirectURI)

	return authURL, nil
}

func (y *YNABAuthService) GetAuthorizationURL(state string, clientID string, redirectURI string) string {
	return "https://app.ynab.com/oauth/authorize?" +
		"client_id=" + url.QueryEscape(clientID) +
		"&redirect_uri=" + url.QueryEscape(redirectURI) +
		"&response_type=code" +
		"&state=" + url.QueryEscape(state)
}

func (y *YNABAuthService) ExchangeCodeForTokens(code string, userID uuid.UUID) error {
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
		return fmt.Errorf("failed to exchange code: %w", err)
	}
	defer resp.Body.Close()

	var tokenResponse TokenResponse
	if err := json.NewDecoder(resp.Body).Decode(&tokenResponse); err != nil {
		return fmt.Errorf("failed to decode token response: %w", err)
	}

	err = y.StoreAccessToken(&tokenResponse, userID)
	if err != nil {
		return fmt.Errorf("failed to store token: %w", err)
	}

	return nil
}

func (y *YNABAuthService) StoreAccessToken(tokenResponse *TokenResponse, userID uuid.UUID) error {
	if userID == uuid.Nil {
		return fmt.Errorf("invalid user ID")
	}

	expiresAt := time.Now().Add(time.Duration(tokenResponse.ExpiresIn) * time.Second)

	token := models.YNABToken{
		UserID:       userID,
		AccessToken:  tokenResponse.AccessToken,
		RefreshToken: tokenResponse.RefreshToken,
		ExpiresAt:    expiresAt,
	}

	result := y.db.Where("user_id = ?", userID).Assign(token).FirstOrCreate(&token)
	if result.Error != nil {
		return fmt.Errorf("failed to store token: %w", result.Error)
	}

	return nil
}

func (y *YNABAuthService) GetAccessToken(userID uuid.UUID) (string, error) {
	var token models.YNABToken
	result := y.db.Where("user_id = ?", userID).First(&token)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return "", gorm.ErrRecordNotFound
		}
		return "", fmt.Errorf("failed to get token: %w", result.Error)
	}

	return token.AccessToken, nil
}

type TokenResponse struct {
	AccessToken  string `json:"access_token"`
	TokenType    string `json:"token_type"`
	ExpiresIn    int    `json:"expires_in"`
	RefreshToken string `json:"refresh_token"`
}
