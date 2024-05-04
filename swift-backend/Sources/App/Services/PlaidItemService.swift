@preconcurrency import Fluent
import Vapor

struct PlaidItemService {
    let db: Database

    func getById(id: UUID) async throws -> PlaidItem? {
        return try await PlaidItem.query(on: db).filter(\.$id == id).first()
    }

    func getByPlaidItemId(plaidItemId: String) async throws -> PlaidItem? {
        return try await PlaidItem.query(on: db).filter(\.$plaidItemId == plaidItemId)
            .first()
    }

    func listItems(userId: UUID) async throws -> [PlaidItem] {
        return try await PlaidItem.query(on: db).filter(\.$user.$id == userId).all()
    }

    func createItem(
        userId: UUID,
        accessToken: String,
        itemId: String,
        institutionId: String,
        status: PlaidItem.Status,
        transactionsCursor: String?
    ) async throws -> PlaidItem {
        let item = PlaidItem(
            userId: userId,
            plaidAccessToken: accessToken,
            plaidItemId: itemId,
            plaidInstitutionId: institutionId,
            status: status.rawValue,
            transactionsCursor: transactionsCursor
        )
        try await item.save(on: db)
        return item
    }

    func getByInstitutionId(institutionId: String) async throws -> PlaidItem? {
        return try await PlaidItem.query(on: db).filter(
            \.$plaidInstitutionId == institutionId
        ).first()
    }

    func updateCursor(itemId: UUID, cursor: String) async throws {
        try await PlaidItem.query(on: db).set(\.$transactionsCursor, to: cursor).filter(
            \.$id == itemId
        ).update()
    }
}
