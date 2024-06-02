import Fluent
import FluentPostgresDriver

extension PlaidItem {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(PlaidItem.schema)
                .field(
                    "id",
                    .uuid,
                    .identifier(auto: false),
                    .required,
                    .sql(.default(SQLFunction("uuid_generate_v4")))
                )
                .field(
                    "user_id",
                    .uuid,
                    .required,
                    .references("users", "id")
                )
                .field("plaid_access_token", .string, .required).unique(
                    on: "plaid_access_token"
                )
                .field("plaid_item_id", .string, .required).unique(on: "plaid_item_id")
                .field("plaid_institution_id", .string, .required)
                .field(
                    "status",
                    .string,
                    .required
                )
                .field("transactions_cursor", .string)
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
                .create(index: "ix:\(PlaidItem.schema).user_id")
                .on(PlaidItem.schema)
                .column("user_id")
                .run()
        }

        func revert(on database: Database) async throws {
            try await database.schema(PlaidItem.schema).delete()
        }
    }
}
