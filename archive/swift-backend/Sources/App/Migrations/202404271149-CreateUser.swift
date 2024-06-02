import Fluent
import FluentPostgresDriver

extension User {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(User.schema)
                .field(
                    "id",
                    .uuid,
                    .identifier(auto: false),
                    .required,
                    .sql(.default(SQLFunction("uuid_generate_v4")))
                )
                .field("email", .string, .required)
                .unique(on: "email")
                .field("password_hash", .string)
                .field("apple_sub", .string)
                .unique(on: "apple_sub")
                .field(
                    "created_at",
                    .datetime,
                    .required,
                    .sql(.default(SQLFunction("now")))
                ).field(
                    "updated_at",
                    .datetime,
                    .required,
                    .sql(.default(SQLFunction("now")))
                ).field("deleted_at", .datetime)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(User.schema).delete()
        }
    }
}
