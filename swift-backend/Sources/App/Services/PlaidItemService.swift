@preconcurrency import Fluent

struct PlaidItemService {
    let db: Database

    func listItems(userId: UUID) async throws -> [PlaidItem] {
        return try await PlaidItem.query(on: db)
            .filter(\.$user.$id == userId)
            .all()
    }
}
