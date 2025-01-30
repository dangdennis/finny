package ynab_client

import "net/http"

type AuthHttpDoer struct {
	accessToken string
	client      *http.Client
}

func (a *AuthHttpDoer) Do(req *http.Request) (*http.Response, error) {
	req.Header.Set("Authorization", "Bearer "+a.accessToken)
	return a.client.Do(req)
}
