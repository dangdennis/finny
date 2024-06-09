package main

import (
	"errors"
	"os"

	"github.com/plaid/plaid-go/v25/plaid"
)

type PlaidCreds struct {
	Env      plaid.Environment
	ClientID string
	Secret   string
}

func GetPlaidCreds() (*PlaidCreds, error) {
	plaidClientID := os.Getenv("PLAID_CLIENT_ID")
	plaidEnv := os.Getenv("PLAID_ENV")

	if plaidEnv != "sandbox" && plaidEnv != "development" && plaidEnv != "production" {
		return nil, errors.New("Invalid Plaid environment")
	}

	var plaidSecretString string
	var plaidEnvUrl plaid.Environment
	switch plaidEnv {
	case "sandbox":
		plaidSecretString = os.Getenv("PLAID_SECRET_SANDBOX")
		plaidEnvUrl = plaid.Sandbox
	case "development":
		plaidSecretString = os.Getenv("PLAID_SECRET_DEVELOPMENT")
		plaidEnvUrl = plaid.Development
	case "production":
		plaidSecretString = os.Getenv("PLAID_SECRET_PRODUCTION")
		plaidEnvUrl = plaid.Production
	}
	if len(plaidClientID) == 0 || len(plaidSecretString) == 0 {
		return nil, errors.New("Plaid credentials not set")
	}

	return &PlaidCreds{
		Env:      plaidEnvUrl,
		ClientID: plaidClientID,
		Secret:   plaidSecretString,
	}, nil
}
