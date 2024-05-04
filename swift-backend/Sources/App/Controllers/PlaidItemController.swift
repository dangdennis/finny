@preconcurrency import Fluent
import Plaid
import Vapor

struct PlaidItemController: Sendable {
    let db: Database
    let plaidItemService: PlaidItemService
    let accountService: AccountService
    let transactionService: TransactionService
    let syncService: SyncService
    let plaid: PlaidClient

    func linkItem(req: Request) async throws -> PlaidItem.CreateItemResponse {
        try PlaidItem.CreateItemRequest.validate(content: req)
        let userId = try Auth.getUserId(from: req)
        let content = try req.content.decode(PlaidItem.CreateItemRequest.self)
        let item = try await plaidItemService.getByInstitutionId(
            institutionId: content.institutionId
        )
        if item != nil {
            throw Abort(.badRequest, reason: "You have already linked this institution.")
        }

        let exchanged = try await plaid.exchangePublicToken(
            publicToken: content.publicToken
        )

        let newItem = try await plaidItemService.createItem(
            userId: userId,
            accessToken: exchanged.access_token,
            itemId: exchanged.item_id,
            institutionId: content.institutionId,
            status: .success,
            transactionsCursor: nil
        )

        let itemId = try newItem.requireID()

        syncService.syncTransactionsAndAccounts(itemId: itemId, logger: req.logger)

        return .init(
            data: .init(
                id: try newItem.requireID(),
                itemId: newItem.plaidItemId,
                institutionId: newItem.plaidInstitutionId,
                status: newItem.status,
                createdAt: newItem.createdAt!
            )
        )
    }

    func listItems(req: Request) async throws -> PlaidItem.ListItemsResponse {
        let sessionToken = try req.auth.require(SessionToken.self)
        let userId = UUID(uuidString: sessionToken.sub.value)!
        let items = try await plaidItemService.listItems(userId: userId)
        return try PlaidItem.ListItemsResponse(
            data: items.map { item in
                PlaidItem.DTO(
                    id: try item.requireID(),
                    itemId: item.plaidItemId,
                    institutionId: item.plaidInstitutionId,
                    status: item.status,
                    createdAt: item.createdAt!
                )
            }
        )
    }

    func syncItem(req: Request) async throws -> HTTPStatus {
        try PlaidItem.SyncItemRequest.validate(content: req)
        let content = try req.content.decode(PlaidItem.SyncItemRequest.self)
        let plaidItem = try await plaidItemService.getById(id: content.itemId)
        guard let plaidItem = plaidItem else {
            throw Abort(.notFound, reason: "Item not found.")
        }
        syncService.syncTransactionsAndAccounts(
            itemId: try plaidItem.requireID(),
            logger: req.logger
        )
        return .ok
    }
}

extension PlaidItem {
    struct DTO: Content {
        let id: UUID
        let itemId: String
        let institutionId: String
        let status: String
        let createdAt: Date
    }

    struct ListItemsResponse: DataContaining { var data: [DTO] }

    struct CreateItemRequest: Content {
        let publicToken: String
        let institutionId: String
    }

    struct CreateItemResponse: DataContaining { var data: DTO }

    struct SyncItemRequest: Content { let itemId: UUID }

    struct SyncItemResponse: DataContaining { var data: DTO }
}

extension PlaidItem.CreateItemRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("publicToken", as: String.self, is: !.empty)
        validations.add("institutionId", as: String.self, is: !.empty)
    }
}

extension PlaidItem.SyncItemRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("itemId", as: UUID.self, is: .valid)
    }
}
