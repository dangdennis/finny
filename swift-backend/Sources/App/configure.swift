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

    try applyDatabaseConfig(app: app, databaseUrl: Environment.get("DATABASE_URL")!)

    app.migrations.add(PGExtensionMigration())
    app.migrations.add(User.Migration())
    app.migrations.add(PlaidItem.Migration())
    app.migrations.add(Asset.Migration())
    app.migrations.add(Account.Migration())
    app.migrations.add(Transaction.Migration())
    app.migrations.add(PlaidLinkEvent.Migration())
    app.migrations.add(PlaidApiEvent.Migration())
    app.migrations.add(Goal.Migration())
    try await app.autoMigrate()

    app.views.use(.leaf)

    // todo: set jwt secret
    app.jwt.signers.use(.hs256(key: "secret"))
    app.asyncCommands.use(HelloCommand(), as: "hello")
    app.asyncCommands.use(PlaidCommand(), as: "plaid")

    // register routes
    try routes(app)
}
