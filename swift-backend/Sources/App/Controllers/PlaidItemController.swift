@preconcurrency import Fluent
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
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

  func exchangePublicToken(req: Request) async throws -> PlaidItem.ExchangePublicTokenResponse {
    try PlaidItem.ExchangePublicTokenRequest.validate(content: req)
    let sessionToken = try req.auth.require(SessionToken.self)
    let _ = try req.content.decode(PlaidItem.ExchangePublicTokenRequest.self)
    //  exchange publicToken for access_token /item/public_token/exchange

    // let plaid = (
    //   serverURL: URL(string: "https://sandbox.plaid.com")!, transport: AsyncHTTPClientTransport())
    let _ = UUID(uuidString: sessionToken.sub.value)!
    // create the PlaidItem
    // let sessionToken = try req.auth.require(SessionToken.self)
    // let _ = UUID(uuidString: sessionToken.sub.value)!
    // let publicToken = try req.content.decode(PlaidItem.ExchangePublicTokenRequest.self).publicToken
    // try await plaidItemService.exchangePublicToken(userId: userId, publicToken: publicToken)
    return PlaidItem.ExchangePublicTokenResponse(
      data: PlaidItem.DTO(
        id: UUID(),
        name: "name",
        itemId: "itemId",
        institutionId: "institutionId",
        status: "status",
        createdAt: Date()
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
