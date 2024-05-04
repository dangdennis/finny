import Fluent
import FluentPostgresDriver

extension Account {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(Account.schema).id().field(
                "item_id",
                .uuid,
                .required,
                .references("plaid_items", "id")
            ).field("plaid_account_id", .string, .required).unique(on: "plaid_account_id").field(
                "name",
                .string,
                .required
            ).field("mask", .string).field("official_name", .string).field(
                "current_balance",
                .double,
                .required,
                .sql(.default(0))
            ).field("available_balance", .double, .required, .sql(.default(0))).field(
                "iso_currency_code",
                .string
            ).field("unofficial_currency_code", .string).field("type", .string).field(
                "subtype",
                .string
            ).field("created_at", .datetime, .required, .sql(.default(SQLFunction("now")))).field(
                "updated_at",
                .datetime,
                .required,
                .sql(.default(SQLFunction("now")))
            ).field("deleted_at", .datetime).create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Account.schema).delete()
        }
    }
}
