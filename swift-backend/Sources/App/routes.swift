import Fluent
import Plaid
import Vapor

func routes(_ app: Application) throws {
    let plaid = try PlaidClient(clientId: "todo", secret: "todo", env: .sandbox)

    // Services
    let plaidLinkService = PlaidLinkService(db: app.db)
    let plaidLinkController = PlaidLinkController(plaidLinkService: plaidLinkService, plaid: plaid)
    let plaidItemService = PlaidItemService(db: app.db)
    let accountService = AccountService(db: app.db, plaidItemService: plaidItemService)
    let userService = UserService(db: app.db)
    let transactionService = TransactionService(db: app.db, accountService: accountService)
    let syncService = SyncService(
        plaid: plaid,
        plaidItemService: plaidItemService,
        accountService: accountService,
        transactionService: transactionService
    )

    // Controllers
    let plaidItemController = PlaidItemController(
        db: app.db,
        plaidItemService: plaidItemService,
        accountService: accountService,
        transactionService: transactionService,
        syncService: syncService,
        plaid: plaid
    )
    let userController = UserController(db: app.db, userService: userService)

    app.get { req async throws in try await req.view.render("index", ["title": "Finny"]) }

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
            plaidItems.post("/new") { req async throws in
                return try await plaidItemController.createItem(req: req)
            }

            plaidItems.get("list") { req async throws in
                return try await plaidItemController.listItems(req: req)
            }
        }

        protectedApi.group("plaid-link") { plaidLink in
            plaidLink.post("new") { req async throws in
                return try await plaidLinkController.createLinkToken(req: req)
            }
        }
    }
}
