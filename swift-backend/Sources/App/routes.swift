import Fluent
import Plaid
import Vapor

func routes(_ app: Application) throws {
    guard let plaidEnv = Environment.get("PLAID_ENV") else {
        fatalError("PLAID_ENV environment variable not set")
    }
    guard let plaidClientID = Environment.get("PLAID_CLIENT_ID") else {
        fatalError("PLAID_CLIENT_ID environment variable not set")
    }
    var plaidSecret: String
    var plaidEnvConfig: Plaid.PlaidClient.Environment
    if plaidEnv == "sandbox" {
        guard let plaidSecretSandbox = Environment.get("PLAID_SECRET_SANDBOX") else {
            fatalError("PLAID_SECRET_SANDBOX environment variable not set")
        }
        plaidSecret = plaidSecretSandbox
        plaidEnvConfig = .sandbox
    } else if plaidEnv == "production" {
        guard let plaidSecretProduction = Environment.get("PLAID_SECRET_PRODUCTION")
        else {
            fatalError("PLAID_SECRET_PRODUCTION environment variable not set")
        }
        plaidSecret = plaidSecretProduction
        plaidEnvConfig = .production
    } else if plaidEnv == "development" {
        guard let plaidSecretDevelopment = Environment.get("PLAID_SECRET_DEVELOPMENT")
        else {
            fatalError("PLAID_SECRET_DEVELOPMENT environment variable not set")
        }
        plaidSecret = plaidSecretDevelopment
        plaidEnvConfig = .development
    } else {
        fatalError("Invalid PLAID_ENV environment variable: \(plaidEnv)")
    }
    let plaid = try PlaidClient(
        clientID: plaidClientID,
        secret: plaidSecret,
        env: plaidEnvConfig
    )

    // Services
    let plaidLinkService = PlaidLinkService(
        db: app.db,
        plaid: plaid
    )
    let plaidLinkController = PlaidLinkController(
        plaidLinkService: plaidLinkService
    )
    let plaidItemService = PlaidItemService(db: app.db)
    let accountService = AccountService(db: app.db, plaidItemService: plaidItemService)
    let userService = UserService(db: app.db)
    let transactionService = TransactionService(
        db: app.db,
        accountService: accountService
    )
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
    let accountController = AccountController(accountService: accountService)
    let transactionController = TransactionController(
        transactionService: transactionService
    )

    app.get { req async throws in try await req.view.render("index", ["title": "Finny"]) }

    app.group("api") { api in
        api.group("users") { users in
            users.post("register") { req async throws in
                return try await userController.register(req: req)
            }
            users.post("login") { req async throws in
                return try await userController.login(req: req)
            }
        }

        let protectedApi = api.grouped(SessionToken.asyncAuthenticator())

        protectedApi.group("plaid-items") { itemApi in
            itemApi.post("link") { req async throws in
                return try await plaidItemController.linkItem(req: req)
            }

            itemApi.get("list") { req async throws in
                return try await plaidItemController.listItems(req: req)
            }

            itemApi.post("sync") { req async throws in
                return try await plaidItemController.syncItem(req: req)
            }
        }

        protectedApi.group("accounts") { accountApi in
            accountApi.get("list") { req async throws in
                return try await accountController.listAccounts(req: req)
            }
        }

        protectedApi.group("transactions") { transactionApi in
            transactionApi.get("list") { req async throws in
                return try await transactionController.listTransactions(req: req)
            }
        }

        protectedApi.group("plaid-link") { linkApi in
            linkApi.post("new") { req async throws in
                return try await plaidLinkController.createLinkToken(req: req)
            }

            linkApi.post("events") { req async throws in
                return try await plaidLinkController.createLinkEvent(req: req)
            }
        }
    }

    app.group("webhooks") { webhooksApi in
        webhooksApi.post("apple", "notifications") { req async throws -> HTTPStatus in
            app.logger.info("Received Apple notification: \(req.body.string ?? "")")
            return .ok
        }

        webhooksApi.post("plaid", "notifications") { req async throws -> HTTPStatus in
            app.logger.info("Received Plaid webhook: \(req.body.string ?? "")")
            return .ok
        }
    }

}
