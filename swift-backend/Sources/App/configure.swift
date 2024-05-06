import Fluent
import FluentPostgresDriver
import JWT
import Leaf
import NIOSSL
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    guard let databaseUrl = Environment.get("DATABASE_URL") else {
        fatalError("DATABASE_URL environment variable not set")
    }

    app.databases.use(
        DatabaseConfigurationFactory.postgres(
            configuration: try SQLPostgresConfiguration(
                url: databaseUrl
            )
        ),
        as: .psql
    )

    app.migrations.add(PGExtensionMigration())
    app.migrations.add(User.Migration())
    app.migrations.add(PlaidItem.Migration())
    app.migrations.add(Asset.Migration())
    app.migrations.add(Account.Migration())
    app.migrations.add(Transaction.Migration())
    app.migrations.add(PlaidLinkEvent.Migration())
    app.migrations.add(PlaidApiEvent.Migration())
    app.migrations.add(Goal.Migration())
    app.migrations.add(PowerSync.Migration())
    try await app.autoMigrate()

    app.views.use(.leaf)

    // todo: set jwt secret
    app.jwt.signers.use(.hs256(key: "secret"))
    app.asyncCommands.use(HelloCommand(), as: "hello")
    app.asyncCommands.use(PlaidCommand(), as: "plaid")

    // register routes
    try routes(app)
}
