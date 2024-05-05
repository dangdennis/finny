import Fluent
import FluentPostgresDriver

extension PlaidLinkEvent {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(PlaidLinkEvent.schema)
                .field(
                    "id",
                    .uuid,
                    .identifier(auto: false),
                    .required,
                    .sql(.default(SQLFunction("uuid_generate_v4")))
                )
                .field(
                    "type",
                    .string,
                    .required
                )
                .field("user_id", .uuid, .required, .references("users", "id"))
                .field(
                    "link_session_id",
                    .string
                )
                .field("request_id", .string).unique(on: "request_id")
                .field(
                    "error_type",
                    .string
                )
                .field("error_code", .string)
                .field("status", .string)
                .field(
                    "created_at",
                    .datetime,
                    .required,
                    .sql(.default(SQLFunction("now")))
                )
                .field(
                    "updated_at",
                    .datetime,
                    .required,
                    .sql(.default(SQLFunction("now")))
                )
                .field("deleted_at", .datetime).create()

            try await (database as! SQLDatabase)
                .create(index: "\(PlaidLinkEvent.schema)_user_id_index")
                .on(PlaidLinkEvent.schema)
                .column("user_id")
                .run()

        }

        func revert(on database: Database) async throws {
            try await database.schema(PlaidLinkEvent.schema).delete()
        }
    }
}
