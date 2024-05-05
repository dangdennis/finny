import Fluent
import FluentPostgresDriver

struct PGExtensionMigration: AsyncMigration {
    enum MigrationError: Error {
        case failedExtension
    }

    func prepare(on database: Database) async throws {
        if let sql = database as? SQLDatabase {
            try await sql.raw("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";").run()
        } else {
            throw MigrationError.failedExtension
        }
    }

    func revert(on database: Database) async throws {}
}
