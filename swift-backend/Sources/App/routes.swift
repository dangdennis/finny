import Fluent
import Vapor

func routes(_ app: Application) throws {
  app.get { req async throws in
    try await req.view.render("index", ["title": "Finny"])
  }

  // let plaidLinkService = PlaidLinkService(db: app.db)
  // let plaidLinkController = PlaidLinkController(plaidLinkService: plaidLinkService)
  let plaidItemService = PlaidItemService(db: app.db)
  let plaidItemController = PlaidItemController(db: app.db, plaidItemService: plaidItemService)
  let userService = UserService(db: app.db)
  let userController = UserController(
    db: app.db, userService: userService)

  app.group("api") { api in
    let protectedApi = api.grouped(SessionToken.asyncAuthenticator())

    api.group("users") { users in
      users.post("register") { req async throws in
        return try await userController.create(req: req)
      }
      users.post("login") { req async throws in
        return try await userController.login(req: req)
      }
    }

    protectedApi.group("plaid-items") { plaidItems in
      plaidItems.get("list") { req async throws in
        return try await plaidItemController.list(req: req)
      }
    }
  }
}
