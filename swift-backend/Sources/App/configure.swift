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

    if let databaseUrl = Environment.get("DATABASE_URL") {
        print("DATABASE_URL: \(databaseUrl)")
        let parsed = URLComponents(string: databaseUrl)!
        app.databases.use(
            DatabaseConfigurationFactory.postgres(
                configuration: .init(
                    hostname: parsed.host!,
                    port: parsed.port.flatMap(Int.init(_:))
                        ?? SQLPostgresConfiguration.ianaPortNumber,
                    username: parsed.user!,
                    password: parsed.password!,
                    database: parsed.path.trimmingCharacters(
                        in: CharacterSet(charactersIn: "/")
                    ),
                    tls: .prefer(try .init(configuration: .clientDefault))
                )
            ),
            as: .psql
        )
    } else {
        throw Abort(.internalServerError, reason: "DATABASE_URL not set")
        // app.databases.use(
        //     DatabaseConfigurationFactory.postgres(
        //         configuration: .init(
        //             hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        //             port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:))
        //                 ?? SQLPostgresConfiguration.ianaPortNumber,
        //             username: Environment.get("DATABASE_USERNAME") ?? "postgres",
        //             password: Environment.get("DATABASE_PASSWORD") ?? "postgres",
        //             database: Environment.get("DATABASE_NAME") ?? "postgres",
        //             tls: .prefer(try .init(configuration: .clientDefault))
        //         )
        //     ),
        //     as: .psql
        // )
    }

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
