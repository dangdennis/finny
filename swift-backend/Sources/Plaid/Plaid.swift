import Foundation
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime

public struct PlaidClient: Sendable {
    private let client: APIProtocol
    private let plaidSecret: String
    private let plaidClientID: String

    public enum Environment: String {
        case development = "development"
        case sandbox = "sandbox"
        case production = "production"
    }

    /// Creates a new client for GreetingService.
    public init(clientID: String, secret: String, env: Environment) throws {
        let serverURL: URL
        switch env {
        case .development: serverURL = URL(string: "https://development.plaid.com")!
        case .sandbox: serverURL = URL(string: "https://sandbox.plaid.com")!
        case .production: serverURL = URL(string: "https://production.plaid.com")!
        }

        self.client = Client(serverURL: serverURL, transport: AsyncHTTPClientTransport())
        self.plaidSecret = secret
        self.plaidClientID = clientID
    }

    public func getTransactionsSync(
        plaidItemID: String,
        accessToken: String,
        cursor: String?,
        count: Int?
    ) async throws -> Components.Schemas.TransactionsSyncResponse {
        let response = try await client.transactionsSync(
            Operations.transactionsSync.Input(
                body: .json(
                    Components.Schemas.TransactionsSyncRequest(
                        client_id: self.plaidClientID,
                        access_token: accessToken,
                        secret: self.plaidSecret,
                        cursor: cursor,
                        count: count
                    )
                )
            )
        )

        return try response.ok.body.json
    }

    public func createLinkToken(
        userID: UUID
    ) async throws -> Components.Schemas.LinkTokenCreateResponse {
        let response = try await client.linkTokenCreate(
            Operations.linkTokenCreate.Input(
                body: .json(
                    Components.Schemas.LinkTokenCreateRequest(
                        client_name: "Finny",
                        language: "en",
                        country_codes: [Components.Schemas.CountryCode.US],
                        user: Components.Schemas.LinkTokenCreateRequestUser(
                            client_user_id: userID.uuidString
                        )
                    )
                )
            )
        )

        return try response.ok.body.json
    }

    public func getItem(
        itemID: String,
        accessToken: String
    ) async throws -> Components.Schemas.ItemGetResponse {
        let response = try await client.itemGet(
            .init(
                body: .json(
                    .init(
                        client_id: self.plaidClientID,
                        secret: self.plaidSecret,
                        access_token: accessToken

                    )
                )
            )
        )

        return try response.ok.body.json
    }

    public func exchangePublicToken(
        publicToken: String
    ) async throws -> Components.Schemas.ItemPublicTokenExchangeResponse {
        let response = try await client.itemPublicTokenExchange(
            .init(
                body: .json(
                    .init(
                        client_id: self.plaidClientID,
                        secret: self.plaidSecret,
                        public_token: publicToken
                    )
                )
            )
        )

        return try response.ok.body.json
    }

    public func getAccounts(
        accessToken: String
    ) async throws -> Components.Schemas.AccountsGetResponse {
        let response = try await client.accountsGet(
            .init(
                body: .json(
                    .init(
                        client_id: self.plaidClientID,
                        secret: self.plaidSecret,
                        access_token: accessToken
                    )
                )
            )
        )

        return try response.ok.body.json
    }
}
