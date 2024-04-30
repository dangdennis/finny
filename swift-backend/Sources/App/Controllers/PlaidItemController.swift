@preconcurrency import Fluent
import Vapor

struct PlaidItemController {
  let db: Database
  let plaidItemService: PlaidItemService

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
}

extension PlaidItem {
  protocol DataContaining: Content {
    associatedtype DataType: Content
    var data: [DataType] { get set }
  }

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
}
