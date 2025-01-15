package ynab_client

import (
	"github.com/brunomvsouza/ynab.go"
	"github.com/brunomvsouza/ynab.go/api"
	"github.com/brunomvsouza/ynab.go/api/category"
	"github.com/google/uuid"
)

type YNABClient struct {
	client ynab.ClientServicer
}

// todo(dennis): get user's access token instead of using my personal access token
func NewYNABClient(accessToken string) *YNABClient {
	client := ynab.NewClient(accessToken)
	return &YNABClient{client: client}
}

func (c *YNABClient) GetCategories(userID uuid.UUID, lastKnowledgeOfServer uint64) (*category.SearchResultSnapshot, error) {
	var filter *api.Filter
	if lastKnowledgeOfServer > 0 {
		filter = &api.Filter{
			LastKnowledgeOfServer: lastKnowledgeOfServer,
		}
	}

	return c.client.Category().GetCategories("last-used", filter)
}
