import Fluent
import Vapor

func routes(_ app: Application) throws {
  app.get { req async throws in
    try await req.view.render("index", ["title": "Hello Vapor!"])
  }

  // let plaidLinkService = PlaidLinkService(db: app.db)
  // let plaidLinkController = PlaidLinkController(plaidLinkService: plaidLinkService)
  let userService = UserService(db: app.db)
  let userAuthenticatorService = UserAuthenticatorService(db: app.db)
  let userController = UserController(
    db: app.db, userService: userService, userAuthenticatorService: userAuthenticatorService)

  // let protected = app.grouped(UserAuthenticator())

  app.group("api") { api in
    api.group("users") { users in
      users.post("register") { req async throws in
        return try await userController.create(req: req)
      }
      users.post("login") { req async throws in
        return try await userController.login(req: req)
      }
    }
  }

  // try app.register(collection: TodoController())
  // try app.register(collection: AccountController())
}
