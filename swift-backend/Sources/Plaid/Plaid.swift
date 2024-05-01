import Foundation
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime

public struct PlaidClient {
    private let underlyingClient: APIProtocol
    private let plaidSecret: String
    private let plaidClientId: String

    public enum Environment: String {
        case development = "development"
        case sandbox = "sandbox"
        case production = "production"
    }

    /// Creates a new client for GreetingService.
    public init(clientId: String, secret: String, env: Environment) throws {
        let serverURL: URL
        switch env {
        case .development:
            serverURL = URL(string: "https://development.plaid.com")!
        case .sandbox:
            serverURL = URL(string: "https://sandbox.plaid.com")!
        case .production:
            serverURL = URL(string: "https://production.plaid.com")!
        }

        self.underlyingClient = Client(
            serverURL: serverURL,
            transport: AsyncHTTPClientTransport())
        self.plaidSecret = secret
        self.plaidClientId = clientId
    }

    func createLinkToken(userId: UUID) async throws -> Components.Schemas.LinkTokenCreateResponse {
        let response = try await underlyingClient.linkTokenCreate(
            Operations.linkTokenCreate.Input(
                body: .json(
                    Components.Schemas.LinkTokenCreateRequest(
                        client_name: "Finny", language: "en",
                        country_codes: [Components.Schemas.CountryCode.US],
                        user: Components.Schemas.LinkTokenCreateRequestUser(
                            client_user_id: userId.uuidString)))
            )
        )

        return try response.ok.body.json
    }

    func exchangePublicToken(publicToken: String) async throws
        -> Components.Schemas.ItemPublicTokenExchangeResponse
    {
        let response = try await underlyingClient.itemPublicTokenExchange(
            Operations.itemPublicTokenExchange.Input(
                body: .json(
                    Components.Schemas.ItemPublicTokenExchangeRequest(
                        client_id: self.plaidClientId,
                        secret: self.plaidSecret,
                        public_token: publicToken
                    ))
            ))

        return try response.ok.body.json
    }
}
