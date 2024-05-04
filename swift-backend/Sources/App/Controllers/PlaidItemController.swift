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

    func linkItem(req: Request) async throws -> CreateItemResponse {
        try CreateItemRequest.validate(content: req)
        let userID = try Auth.getUserID(from: req)
        let content = try req.content.decode(CreateItemRequest.self)
        let item = try await plaidItemService.getByInstitutionID(
            institutionID: content.institutionID
        )
        if item != nil {
            throw Abort(.badRequest, reason: "You have already linked this institution.")
        }

        let exchanged = try await plaid.exchangePublicToken(
            publicToken: content.publicToken
        )

        let newItem = try await plaidItemService.createItem(
            userID: userID,
            accessToken: exchanged.access_token,
            itemID: exchanged.item_id,
            institutionID: content.institutionID,
            status: .success,
            transactionsCursor: nil
        )

        let itemID = try newItem.requireID()

        syncService.syncTransactionsAndAccounts(itemID: itemID, logger: req.logger)

        return .init(
            data: .init(
                id: try newItem.requireID(),
                institutionID: newItem.plaidInstitutionID,
                status: newItem.status,
                createdAt: newItem.createdAt!
            )
        )
    }

    func listItems(req: Request) async throws -> ListItemsResponse {
        let sessionToken = try req.auth.require(SessionToken.self)
        let userID = UUID(uuidString: sessionToken.sub.value)!
        let items = try await plaidItemService.listItems(userID: userID)
        return try ListItemsResponse(
            data: items.map { item in
                PlaidItem.DTO(
                    id: try item.requireID(),
                    institutionID: item.plaidInstitutionID,
                    status: item.status,
                    createdAt: item.createdAt!
                )
            }
        )
    }

    func syncItem(req: Request) async throws -> HTTPStatus {
        try SyncItemRequest.validate(content: req)
        let content = try req.content.decode(SyncItemRequest.self)
        let plaidItem = try await plaidItemService.getByID(id: content.itemID)
        guard let plaidItem = plaidItem else {
            throw Abort(.notFound, reason: "Item not found.")
        }
        syncService.syncTransactionsAndAccounts(
            itemID: try plaidItem.requireID(),
            logger: req.logger
        )
        return .ok
    }
}

extension PlaidItem {
    struct DTO: Content {
        let id: UUID
        let institutionID: String
        let status: String
        let createdAt: Date
    }
}

extension PlaidItemController {

    struct ListItemsResponse: DataContaining { let data: [PlaidItem.DTO] }

    struct CreateItemRequest: Content {
        let publicToken: String
        let institutionID: String
    }

    struct CreateItemResponse: DataContaining { let data: PlaidItem.DTO }

    struct SyncItemRequest: Content { let itemID: UUID }

    struct SyncItemResponse: DataContaining { let data: PlaidItem.DTO }
}

extension PlaidItemController.CreateItemRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("publicToken", as: String.self, is: !.empty)
        validations.add("institutionID", as: String.self, is: !.empty)
    }
}

extension PlaidItemController.SyncItemRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("itemID", as: UUID.self, is: .valid)
    }
}
