@preconcurrency import Fluent
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import Plaid
import Vapor

struct PlaidItemController: Sendable {
    let db: Database
    let plaidItemService: PlaidItemService
    let plaidClient: PlaidClient

    func list(req: Request) async throws -> PlaidItem.ListResponse {
        let sessionToken = try req.auth.require(SessionToken.self)
        let userId = UUID(uuidString: sessionToken.sub.value)!
        let items = try await plaidItemService.listItems(userId: userId)
        return try PlaidItem.ListResponse(
            data: items.map { item in
                PlaidItem.DTO(
                    id: try item.requireID(),
                    name: item.plaidInstitutionId,
                    itemId: item.plaidItemId,
                    institutionId: item.plaidInstitutionId,
                    status: item.status,
                    createdAt: item.createdAt!
                )
            }
        )
    }

    func exchangePublicToken(req: Request) async throws -> PlaidItem.ExchangePublicTokenResponse {
        try PlaidItem.ExchangePublicTokenRequest.validate(content: req)
        let sessionToken = try req.auth.require(SessionToken.self)
        let exchangeContent = try req.content.decode(PlaidItem.ExchangePublicTokenRequest.self)
        let exchanged = try await plaidClient.exchangePublicToken(
            publicToken: exchangeContent.publicToken)
        let userId = UUID(uuidString: sessionToken.sub.value)!
        let plaidItemExternal = try await plaidClient.getItem(
            itemId: exchanged.item_id, accessToken: exchanged.access_token)
        let plaidItem = try await plaidItemService.createItem(
            userId: userId, accessToken: exchanged.access_token,
            itemId: plaidItemExternal.item.item_id,
            institutionId: plaidItemExternal.item.institution_id!,
            status: "good",
            transactionsCursor: nil)
        return PlaidItem.ExchangePublicTokenResponse(
            data: PlaidItem.DTO(
                id: plaidItem.id!,
                name: "Finny",
                itemId: plaidItem.plaidItemId,
                institutionId: plaidItem.plaidInstitutionId,
                status: plaidItem.status,
                createdAt: plaidItem.createdAt!
            )
        )
    }
}

extension PlaidItem {
    struct DTO: Content {
        let id: UUID
        let name: String
        let itemId: String
        let institutionId: String
        let status: String
        let createdAt: Date
    }

    struct ListResponse: DataContaining {
        var data: [DTO]
    }

    struct ExchangePublicTokenRequest: Content {
        let publicToken: String
    }

    struct ExchangePublicTokenResponse: DataContaining {
        var data: DTO
    }
}

extension PlaidItem.ExchangePublicTokenRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("publicToken", as: String.self, is: !.empty)
    }
}
