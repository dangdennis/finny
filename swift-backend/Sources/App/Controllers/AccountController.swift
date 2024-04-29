import Fluent
import Vapor

struct AccountController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let router = routes.grouped("accounts")

    router.get(use: { try await self.index(req: $0) })
    router.post(use: { try await self.create(req: $0) })
    router.group(":accountId") { todo in
      todo.delete(use: { try await self.delete(req: $0) })
    }
  }

  func index(req: Request) async throws -> [Account] {
    try await Account.query(on: req.db).all()
  }

  func create(req: Request) async throws -> Account {
    let account = try req.content.decode(Account.self)

    try await account.save(on: req.db)
    return account
  }

  func delete(req: Request) async throws -> HTTPStatus {
    guard let account = try await Account.find(req.parameters.get("account_id"), on: req.db)
    else {
      throw Abort(.notFound)
    }

    try await account.delete(on: req.db)
    return .noContent
  }
}
