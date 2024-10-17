package plaid_service

import (
	"context"
	"fmt"

	"github.com/plaid/plaid-go/plaid"
	"gorm.io/gorm"
)

type PlaidService struct {
	client *plaid.APIClient
	db     *gorm.DB
}

func NewPlaidService(db *gorm.DB) (*PlaidService, error) {
	if db == nil {
		return nil, fmt.Errorf("Required database is nil")
	}

	configuration := plaid.NewConfiguration()
	configuration.AddDefaultHeader("PLAID-CLIENT-ID", "client_id")
	configuration.AddDefaultHeader("PLAID-SECRET", "value")
	configuration.UseEnvironment(plaid.Production)
	client := plaid.NewAPIClient(configuration)

	if client == nil {
		return nil, fmt.Errorf("Failed to create Plaid client")
	}

	return &PlaidService{
		client: client,
		db:     db,
	}, nil
}

func (p *PlaidService) GetInvestmentTransactions(accessToken string, itemId string) (plaid.InvestmentsTransactionsGetResponse, error) {
	request := plaid.InvestmentsTransactionsGetRequest{
		AccessToken: accessToken,
		StartDate:   "YYYY-MM-DD",
		EndDate:     "YYYY-MM-DD",
	}

	response, _, err := p.client.PlaidApi.InvestmentsTransactionsGet(context.Background()).InvestmentsTransactionsGetRequest(request).Execute()
	if err != nil {
		return plaid.InvestmentsTransactionsGetResponse{}, err
	}

	return response, nil
}

func (p *PlaidService) UpsertInvestmentTransactions() {

}
