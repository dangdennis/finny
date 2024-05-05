import Fluent
import FluentPostgresDriver

extension Transaction {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(Transaction.schema)
                .field(
                    "id",
                    .uuid,
                    .identifier(auto: false),
                    .required,
                    .sql(.default(SQLFunction("uuid_generate_v4")))
                )
                .field(
                    "account_id",
                    .uuid,
                    .required,
                    .references("accounts", "id")
                )
                .field("plaid_transaction_id", .string, .required).unique(
                    on: "plaid_transaction_id"
                )
                .field("category", .string)
                .field("subcategory", .string)
                .field(
                    "type",
                    .string,
                    .required
                )
                .field("name", .string, .required)
                .field("amount", .double, .required)
                .field(
                    "iso_currency_code",
                    .string
                )
                .field("unofficial_currency_code", .string)
                .field("date", .date, .required)

                .field("pending", .bool, .required)
                .field("account_owner", .string)
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
                .create(index: "\(Transaction.schema)_account_id_index")
                .on(Transaction.schema)
                .column("account_id")
                .run()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Transaction.schema).delete()
        }
    }
}
