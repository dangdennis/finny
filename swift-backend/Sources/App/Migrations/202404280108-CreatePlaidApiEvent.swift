import Fluent
import FluentPostgresDriver

extension PlaidApiEvent {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(PlaidApiEvent.schema)
                .field(
                    "id",
                    .uuid,
                    .identifier(auto: false),
                    .required,
                    .sql(.default(SQLFunction("uuid_generate_v4")))
                )
                .field(
                    "item_id",
                    .uuid,
                    .required,
                    .references("plaid_items", "id")
                )
                .field("user_id", .uuid, .required, .references("users", "id"))
                .field(
                    "plaid_method",
                    .string,
                    .required
                )
                .field("arguments", .string)
                .field("request_id", .string).unique(
                    on: "request_id"
                )
                .field("error_type", .string)
                .field("error_code", .string)
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
                .create(index: "\(PlaidApiEvent.schema)_item_id_index")
                .on(PlaidApiEvent.schema)
                .column("item_id")
                .run()
        }

        func revert(on database: Database) async throws {
            try await database.schema(PlaidApiEvent.schema).delete()
        }
    }
}
