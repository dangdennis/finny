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

  app.databases.use(
    DatabaseConfigurationFactory.postgres(
      configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:))
          ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "postgres",
        password: Environment.get("DATABASE_PASSWORD") ?? "postgres",
        database: Environment.get("DATABASE_NAME") ?? "postgres",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

  app.migrations.add(CreateUser())
  app.migrations.add(CreatePlaidItem())
  app.migrations.add(CreateAsset())
  app.migrations.add(CreateAccount())
  app.migrations.add(CreateTransaction())
  app.migrations.add(CreatePlaidLinkItem())
  app.migrations.add(CreatePlaidApiEvent())

  app.views.use(.leaf)
  app.jwt.signers.use(.hs256(key: "secret"))
  app.asyncCommands.use(HelloCommand(), as: "hello")
  app.asyncCommands.use(PlaidCommand(), as: "plaid")

  // register routes
  try routes(app)
}
