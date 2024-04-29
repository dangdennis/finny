import Fluent
import Vapor

func routes(_ app: Application) throws {
  app.get { req async throws in
    try await req.view.render("index", ["title": "Hello Vapor!"])
  }

  // let plaidLinkService = PlaidLinkService(db: app.db)
  // let plaidLinkController = PlaidLinkController(plaidLinkService: plaidLinkService)
  let userService = UserService(db: app.db)
  let userController = UserController(db: app.db, userService: userService)

  app.group("api") { api in
    api.group("users") { users in
      users.post("new") { req async throws in
        try User.CreateRequest.validate(content: req)
        let user = try await userController.create(
          payload: try req.content.decode(User.CreateRequest.self)
        )
        return User.CreateResponse(id: user.id!, username: user.username)
      }
    }
  }

  // try app.register(collection: TodoController())
  // try app.register(collection: AccountController())
}
