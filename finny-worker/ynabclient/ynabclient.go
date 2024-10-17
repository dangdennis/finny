package ynabclient

import (
	"github.com/brunomvsouza/ynab.go"
)

func NewYNABClient(accessToken string) *ynab.ClientServicer {
	c := ynab.NewClient(accessToken)
	return &c
}
