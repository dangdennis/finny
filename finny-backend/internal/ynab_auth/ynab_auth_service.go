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

type YNABAuth interface {
	GetAccessToken(userID uuid.UUID) (models.YNABToken, error)
}

type YNABAuthService struct {
	randReader RandomReader
	db         *gorm.DB
}

var _ YNABAuth = (*YNABAuthService)(nil)

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

func (y *YNABAuthService) GenerateState() (string, error) {
	b := make([]byte, 32)
	if _, err := y.randReader.Read(b); err != nil {
		return "", err
	}
	return base64.URLEncoding.EncodeToString([]byte(b)), nil
}

func (y *YNABAuthService) InitiateOAuth(clientID string, redirectURI string, userID uuid.UUID) (string, error) {
	state, err := y.GenerateState()
	if err != nil {
		return "", err
	}

	authURL := y.GetAuthorizationURL(state, clientID, redirectURI)

	err = y.StoreState(state, userID)
	if err != nil {
		return "", err
	}

	return authURL, nil
}

func (y *YNABAuthService) GetAuthorizationURL(state string, clientID string, redirectURI string) string {
	return "https://app.ynab.com/oauth/authorize?" +
		"client_id=" + url.QueryEscape(clientID) +
		"&redirect_uri=" + url.QueryEscape(redirectURI) +
		"&response_type=code" +
		"&scope=read-only" +
		"&state=" + url.QueryEscape(state)
}

func (y *YNABAuthService) ExchangeCodeForTokens(code string, state string) error {
	// todo: read at toplevel and add these as private fields to the ynabAuthService struct
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

	userID, err := y.GetUserIDFromState(state)
	if err != nil {
		return fmt.Errorf("failed to get user ID from state: %w", err)
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

func (y *YNABAuthService) GetAccessToken(userID uuid.UUID) (models.YNABToken, error) {
	var token models.YNABToken
	result := y.db.Where("user_id = ?", userID).First(&token)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return token, gorm.ErrRecordNotFound
		}
		return token, fmt.Errorf("failed to get token: %w", result.Error)
	}

	return token, nil
}

func (y *YNABAuthService) CheckAuthStatus(userID uuid.UUID) (bool, error) {
	accessToken, err := y.GetAccessToken(userID)
	if err != nil {
		return false, err
	}

	return accessToken.ExpiresAt.After(time.Now()), nil

}

func (y *YNABAuthService) StoreState(state string, userID uuid.UUID) error {
	oauthState := models.OAuthState{
		State:     state,
		UserID:    userID,
		CreatedAt: time.Now(),
		ExpiresAt: time.Now().Add(5 * time.Minute), // State expires after 5 minutes
	}

	result := y.db.Create(&oauthState)
	return result.Error
}

func (y *YNABAuthService) GetUserIDFromState(code string) (uuid.UUID, error) {
	var oauthState models.OAuthState
	result := y.db.Where("state = ? AND expires_at > ?", code, time.Now()).First(&oauthState)

	if result.Error != nil {
		return uuid.Nil, result.Error
	}

	y.db.Delete(&oauthState)

	return oauthState.UserID, nil
}

func (y *YNABAuthService) DeleteUserOAuthState(userID uuid.UUID) error {
	result := y.db.Unscoped().Where("user_id = ?", userID).Delete(&models.OAuthState{})
	if result.Error != nil {
		return fmt.Errorf("failed to cleanup expired states: %w", result.Error)
	}

	return nil
}

func (y *YNABAuthService) CleanupExpiredStates(olderThan time.Duration) error {
	result := y.db.Where("expires_at < ?", time.Now().Add(-olderThan)).Delete(&models.OAuthState{})
	if result.Error != nil {
		return fmt.Errorf("failed to cleanup expired states: %w", result.Error)
	}

	return nil
}

type TokenResponse struct {
	AccessToken  string `json:"access_token"`
	TokenType    string `json:"token_type"`
	ExpiresIn    int    `json:"expires_in"`
	RefreshToken string `json:"refresh_token"`
}
