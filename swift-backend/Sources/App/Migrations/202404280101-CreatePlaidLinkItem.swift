import Fluent
import FluentPostgresDriver

extension PlaidLinkEvent {
  struct Migration: AsyncMigration {
    func prepare(on database: Database) async throws {
      try await database.schema("plaid_link_events")
        .id()
        .field("type", .string, .required)
        .field("user_id", .uuid, .required, .references("users", "id"))
        .field("link_session_id", .string)
        .field("request_id", .string)
        .unique(on: "request_id")
        .field("error_type", .string)
        .field("error_code", .string)
        .field("status", .string)
        .field("created_at", .datetime, .required, .sql(.default(SQLFunction("now"))))
        .field("updated_at", .datetime, .required, .sql(.default(SQLFunction("now"))))
        .field("deleted_at", .datetime)
        .create()
    }

    func revert(on database: Database) async throws {
      try await database.schema("plaid_link_events").delete()
    }
  }
}
