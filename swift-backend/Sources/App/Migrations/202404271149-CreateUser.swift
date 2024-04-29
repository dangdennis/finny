import Fluent
import FluentPostgresDriver

extension User {
  struct Migration: AsyncMigration {
    func prepare(on database: Database) async throws {
      try await database.schema("users")
        .id()
        .field("username", .string, .required)
        .unique(on: "username")
        .field("password_hash", .string, .required)
        .field("created_at", .datetime, .required, .sql(.default(SQLFunction("now"))))
        .field("updated_at", .datetime, .required, .sql(.default(SQLFunction("now"))))
        .field("deleted_at", .datetime)
        .create()
    }

    func revert(on database: Database) async throws {
      try await database.schema("users").delete()
    }
  }
}
