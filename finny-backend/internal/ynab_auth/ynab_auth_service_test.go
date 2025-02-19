package ynab_auth

import (
	"fmt"
	"net/url"
	"testing"

	"github.com/finny/finny-backend/internal/database"
	"github.com/finny/finny-backend/internal/test_utils"
)

type MockRandomReader struct {
}

func (m *MockRandomReader) Read(b []byte) (int, error) {
	for i := range b {
		b[i] = byte(i)
	}
	return len(b), nil
}

func TestInitiateOAuth(t *testing.T) {
	// Mock out the rand, db, and uuid
	mockRandReader := &MockRandomReader{}
	db, err := database.NewDatabase("postgresql://postgres:postgres@127.0.0.1:54322/postgres")
	if err != nil {
		t.Error(err, "Failed to connect to database")
	}
	ynabService, err := NewYNABAuthService(mockRandReader, db)
	if err != nil {
		t.Error(err, "Failed to create YNAB service")
	}

	randomEmail := test_utils.GenerateRandomEmail()
	randomPassword := test_utils.GenerateRandomPassword()
	userID, err := test_utils.CreateAuthUser(db, randomEmail, randomPassword)
	if err != nil {
		t.Error(err, "Failed to create user")
	}
	defer func() {
		err = ynabService.DeleteUserOAuthState(userID)
		if err != nil {
			t.Error(err, "Failed to delete user state")
		}
	}()

	mockClientID := "xxxxfinny"
	mockRedirectURI := "https://api.finny.com/api/ynab/oauth/callback"

	gotURL, err := ynabService.InitiateOAuth(mockClientID, mockRedirectURI, userID)
	if err != nil {
		t.Error(err, "Failed to initiate OAuth")
	}
	expectedState := "AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8%3D"
	expectedURL := "https://app.ynab.com/oauth/authorize?client_id=" + url.QueryEscape(mockClientID) + "&redirect_uri=" + url.QueryEscape(mockRedirectURI) + "&response_type=code&scope=read-only&state=" + expectedState
	if gotURL != expectedURL {
		fmt.Println(gotURL)
		fmt.Println(expectedURL)
		t.Error("Invalid URL")
	}

}

func TestStoreToken(t *testing.T) {
	db, err := database.NewDatabase("postgresql://postgres:postgres@127.0.0.1:54322/postgres")
	if err != nil {
		t.Error(err, "Failed to connect to database")
	}

	randomEmail := test_utils.GenerateRandomEmail()
	randomPassword := test_utils.GenerateRandomPassword()
	userID, err := test_utils.CreateAuthUser(db, randomEmail, randomPassword)
	if err != nil {
		t.Error(err, "Failed to create user")
	}
	ynabService, err := NewYNABAuthService(nil, db)
	if err != nil {
		t.Error(err, "Failed to create YNAB service")
	}

	mockTokenResponse := &TokenResponse{
		RefreshToken: "refresh-token",
		ExpiresIn:    20,
		TokenType:    "token-type",
		AccessToken:  "access-token",
	}

	err = ynabService.StoreAccessToken(mockTokenResponse, userID)
	if err != nil {
		t.Error(err, "Failed to store token")
	}

	// Check if the token was stored correctly
	gotAccessToken, err := ynabService.GetAccessToken(userID)
	if err != nil {
		t.Error(err, "Failed to get access token")
	}

	if gotAccessToken.AccessToken != mockTokenResponse.AccessToken {
		t.Error("Access token does not match")
	}

	err = test_utils.CleanupAuthUser(db, userID)
	if err != nil {
		t.Error(err, "Failed to clean up user")
	}
}
