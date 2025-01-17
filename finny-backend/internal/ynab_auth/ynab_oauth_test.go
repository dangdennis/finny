package ynab_auth

import (
	"net/url"
	"testing"
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
	mockRandReader := &MockRandomReader{}

	ynabService := NewYNABAuthService(mockRandReader)
	mockClientID := "xxxxfinny"
	mockRedirectURI := "https://api.finny.com/api/ynab/oauth/callback"

	gotURL, err := ynabService.InitiateOAuth(mockClientID, mockRedirectURI)
	if err != nil {
		t.Error(err, "Failed to initiate OAuth")
	}
	expectedURL := "https://app.ynab.com/oauth/authorize?client_id=" + url.QueryEscape(mockClientID) + "&redirect_uri=" + url.QueryEscape(mockRedirectURI) + "&response_type=code&state=AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8%3D"

	if gotURL != expectedURL {
		t.Error("Invalid URL")
	}
}
