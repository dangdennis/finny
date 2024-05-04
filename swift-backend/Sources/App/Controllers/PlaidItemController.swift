@preconcurrency import Fluent
import Plaid
import Vapor

struct PlaidItemController: Sendable {
    let db: Database
    let plaidItemService: PlaidItemService
    let accountService: AccountService
    let plaid: PlaidClient

    func createItem(req: Request) async throws -> PlaidItem.CreateItemResponse {
        try PlaidItem.CreateItemRequest.validate(content: req)
        let userId = try Auth.getUserId(from: req)
        let content = try req.content.decode(PlaidItem.CreateItemRequest.self)
        let item = try await plaidItemService.getByInstitutionId(
            institutionId: content.institutionId
        )
        if item != nil {
            throw Abort(.badRequest, reason: "You have already linked this institution.")
        }

        let exchanged = try await plaid.exchangePublicToken(publicToken: content.publicToken)

        let newItem = try await plaidItemService.createItem(
            userId: userId,
            accessToken: exchanged.access_token,
            itemId: exchanged.item_id,
            institutionId: content.institutionId,
            status: .success,
            transactionsCursor: nil
        )

        let itemId = try newItem.requireID()

        // todo: move task to a persistent queue
        Task {
            do {
                guard let item = try await plaidItemService.getById(id: itemId) else {
                    req.logger.error(
                        "Cannot sync transactions. Failed to fetch item with id \(itemId)"
                    )
                    return
                }

                let batchSize = 100
                var cursor = item.transactionsCursor
                var hasMore = true
                var added: [Components.Schemas.Transaction] = []
                var updated: [Components.Schemas.Transaction] = []
                var removed: [Components.Schemas.RemovedTransaction] = []

                while hasMore {

                    let data = try await plaid.getTransactionsSync(
                        plaidItemId: item.plaidItemId,
                        accessToken: item.plaidAccessToken,
                        cursor: cursor,
                        count: batchSize
                    )

                    added.append(contentsOf: data.added)
                    updated.append(contentsOf: data.modified)
                    removed.append(contentsOf: data.removed)

                    hasMore = data.has_more
                    cursor = data.next_cursor
                }

                let accountsResponse = try await plaid.getAccounts(
                    accessToken: item.plaidAccessToken
                )
                try await accountService.upsertAccounts(
                    plaidItemId: item.plaidItemId,
                    accounts: accountsResponse.accounts
                )
                // await createOrUpdateTransactions(added.concat(modified));
                // await deleteTransactions(removed);
                guard let cursor = cursor else {
                    req.logger.error("Cursor is nil. Cannot update cursor.")
                    return
                }
                try await plaidItemService.updateCursor(
                    itemId: try item.requireID(),
                    cursor: cursor
                )

            } catch { print("Failed to fetch transactions: \(error)") }
        }

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
}

extension PlaidItem.CreateItemRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("publicToken", as: String.self, is: !.empty)
        validations.add("institutionId", as: String.self, is: !.empty)
    }
}
