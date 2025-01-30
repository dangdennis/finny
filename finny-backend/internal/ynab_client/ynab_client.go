package ynab_client

import (
	"net/http"

	"github.com/finny/finny-backend/internal/ynab_openapi"
)

const (
	baseURL = "https://api.ynab.com/v1"
)

type YNABClient struct {
	AccessToken string
	Client      *ynab_openapi.ClientWithResponses
}

func NewYNABClient(accessToken string) (*YNABClient, error) {
	authDoer := &AuthHttpDoer{
		accessToken: accessToken,
		client:      &http.Client{},
	}

	client, err := ynab_openapi.NewClientWithResponses(baseURL, ynab_openapi.WithHTTPClient(authDoer))
	if err != nil {
		return nil, err
	}

	return &YNABClient{
		AccessToken: accessToken,
		Client:      client,
	}, nil
}

type AuthHttpDoer struct {
	accessToken string
	client      *http.Client
}

func (a *AuthHttpDoer) Do(req *http.Request) (*http.Response, error) {
	req.Header.Set("Authorization", "Bearer "+a.accessToken)
	return a.client.Do(req)
}

// func (c *YNABClient) makeRequest(endpoint string) ([]byte, error) {
// 	req, err := http.NewRequest("GET", baseURL+endpoint, nil)
// 	if err != nil {
// 		return nil, fmt.Errorf("error creating request: %w", err)
// 	}

// 	req.Header.Set("Authorization", "Bearer "+c.accessToken)

// 	resp, err := c.httpClient.Do(req)
// 	if err != nil {
// 		return nil, fmt.Errorf("error making request: %w", err)
// 	}
// 	defer resp.Body.Close()

// 	if resp.StatusCode != http.StatusOK {
// 		return nil, fmt.Errorf("unexpected status code: %d", resp.StatusCode)
// 	}

// 	body, err := io.ReadAll(resp.Body)
// 	if err != nil {
// 		return nil, fmt.Errorf("error reading response body: %w", err)
// 	}

// 	return body, nil
// }

// func (c *YNABClient) GetLastUsedBudget() (*Budget, error) {
// 	body, err := c.makeRequest("/budgets/last-used")
// 	if err != nil {
// 		return nil, err
// 	}

// 	var response LastUsedBudgetResponse
// 	if err := json.Unmarshal(body, &response); err != nil {
// 		return nil, fmt.Errorf("error unmarshaling response: %w", err)
// 	}

// 	return response.Data.Budget, nil
// }

// func (c *YNABClient) GetBudgets() ([]*Budget, error) {
// 	body, err := c.makeRequest("/budgets")
// 	if err != nil {
// 		return nil, err
// 	}

// 	var response BudgetResponse
// 	if err := json.Unmarshal(body, &response); err != nil {
// 		return nil, fmt.Errorf("error unmarshaling response: %w", err)
// 	}

// 	return response.Data.Budgets, nil
// }

// // package ynab_client

// // import (
// // 	"github.com/brunomvsouza/ynab.go"
// // 	"github.com/brunomvsouza/ynab.go/api"
// // 	"github.com/brunomvsouza/ynab.go/api/budget"
// // 	"github.com/brunomvsouza/ynab.go/api/category"
// // 	"github.com/google/uuid"
// // )

// // type YNABClient struct {
// // 	client ynab.ClientServicer
// // }

// // func NewYNABClient(accessToken string) *YNABClient {
// // 	client := ynab.NewClient(accessToken)
// // 	return &YNABClient{client: client}
// // }

// // func (c *YNABClient) GetLastUsedBudget() (*budget.Snapshot, error) {
// // 	return c.client.Budget().GetLastUsedBudget(nil)
// // }

// // func (c *YNABClient) GetBudgets() ([]*budget.Summary, error) {
// // 	return c.client.Budget().GetBudgets()
// // }

// // func (c *YNABClient) GetCategories(userID uuid.UUID, lastKnowledgeOfServer uint64) (*category.SearchResultSnapshot, error) {
// // 	var filter *api.Filter
// // 	if lastKnowledgeOfServer > 0 {
// // 		filter = &api.Filter{
// // 			LastKnowledgeOfServer: lastKnowledgeOfServer,
// // 		}
// // 	}

// // 	return c.client.Category().GetCategories("last-used", filter)
// // }
