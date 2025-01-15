package ynab_auth

type YNABAuthService struct {
}

func NewYNABAuthService() *YNABAuthService {
	return &YNABAuthService{}
}

func (y *YNABAuthService) GetAuthorizationURL() string {
	return ""
}
