package ynab_auth

import (
	"fmt"
	"math/rand/v2"
	"net/url"
	"testing"
	"time"

	"github.com/finny/finny-backend/internal/database"
	"github.com/finny/finny-backend/internal/models"
	"github.com/google/uuid"
	"gorm.io/gorm"
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
	mockDB := &gorm.DB{}
	mockUserID := uuid.MustParse("c3831896-7ae7-4b1b-83fc-2fb0ee0a4568")
	ynabService, err := NewYNABAuthService(mockRandReader, mockDB)
	if err != nil {
		t.Error(err, "Failed to create YNAB service")
	}
	mockClientID := "xxxxfinny"
	mockRedirectURI := "https://api.finny.com/api/ynab/oauth/callback"

	gotURL, err := ynabService.InitiateOAuth(mockClientID, mockRedirectURI, mockUserID)
	if err != nil {
		t.Error(err, "Failed to initiate OAuth")
	}
	expectedState := "AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8="
	expectedURL := "https://app.ynab.com/oauth/authorize?client_id=" + url.QueryEscape(mockClientID) + "&redirect_uri=" + url.QueryEscape(mockRedirectURI) + "&response_type=code&state=" + expectedState

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

	randomEmail := generateRandomEmail()
	randomPassword := generateRandomPassword()
	userID, err := createAuthUser(db, randomEmail, randomPassword)

	ynabService, err := NewYNABAuthService(nil, db)
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

	err = cleanupAuthUser(db, userID)
	if err != nil {
		t.Error(err, "Failed to clean up user")
	}
}

func createAuthUser(db *gorm.DB, email string, password string) (uuid.UUID, error) {
	userID := uuid.New()

	user := models.AuthUser{
		ID:                userID,
		Email:             email,
		EncryptedPassword: password, // Note: In a real-world scenario, you should hash the password before storing it.
		CreatedAt:         time.Now(),
		UpdatedAt:         time.Now(),
	}

	result := db.Create(&user)
	if result.Error != nil {
		return uuid.Nil, result.Error
	}

	return userID, nil
}

func cleanupAuthUser(db *gorm.DB, userID uuid.UUID) error {
	result := db.Where("id = ?", userID).Delete(&models.AuthUser{})
	if result.Error != nil {
		return result.Error
	}

	return nil
}

func generateRandomEmail() string {
	letters := "abcdefghijklmnopqrstuvwxyz"
	randomString := make([]byte, 10)
	for i := range randomString {
		randomString[i] = letters[rand.IntN(len(letters))]
	}
	return string(randomString) + "@example.com"
}

func generateRandomPassword() string {
	const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	password := make([]byte, 16)
	for i := range password {
		password[i] = charset[rand.IntN(len(charset))]
	}
	return string(password)
}
