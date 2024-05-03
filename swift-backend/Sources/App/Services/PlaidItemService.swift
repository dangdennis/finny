@preconcurrency import Fluent

struct PlaidItemService {
    let db: Database

    func listItems(userId: UUID) async throws -> [PlaidItem] {
        return try await PlaidItem.query(on: db)
            .filter(\.$user.$id == userId)
            .all()
    }

    func createItem(
        userId: UUID, accessToken: String, itemId: String, institutionId: String, status: String,
        transactionsCursor: String?
    ) async throws -> PlaidItem {
        let item = PlaidItem(
            userId: userId, plaidAccessToken: accessToken, plaidItemId: itemId,
            plaidInstitutionId: institutionId, status: status,
            transactionsCursor: transactionsCursor)
        try await item.save(on: db)
        return item
    }
}
