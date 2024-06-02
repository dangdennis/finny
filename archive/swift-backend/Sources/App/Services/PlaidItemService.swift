@preconcurrency import Fluent
import Vapor

struct PlaidItemService {
    let db: Database

    func getByID(id: UUID) async throws -> PlaidItem? {
        return try await PlaidItem.query(on: db).filter(\.$id == id).first()
    }

    func getByPlaidItemID(plaidItemID: String) async throws -> PlaidItem? {
        return try await PlaidItem.query(on: db).filter(\.$plaidItemID == plaidItemID)
            .first()
    }

    func listItems(userID: UUID) async throws -> [PlaidItem] {
        return try await PlaidItem.query(on: db).filter(\.$user.$id == userID).all()
    }

    func createItem(
        userID: UUID,
        accessToken: String,
        itemID: String,
        institutionID: String,
        status: PlaidItem.Status,
        transactionsCursor: String?
    ) async throws -> PlaidItem {
        let item = PlaidItem(
            userID: userID,
            plaidAccessToken: accessToken,
            plaidItemID: itemID,
            plaidInstitutionID: institutionID,
            status: status.rawValue,
            transactionsCursor: transactionsCursor
        )
        try await item.save(on: db)
        return item
    }

    func getByInstitutionID(institutionID: String) async throws -> PlaidItem? {
        return try await PlaidItem.query(on: db).filter(
            \.$plaidInstitutionID == institutionID
        ).first()
    }

    func updateCursor(itemID: UUID, cursor: String) async throws {
        try await PlaidItem.query(on: db).set(\.$transactionsCursor, to: cursor).filter(
            \.$id == itemID
        ).update()
    }
}
