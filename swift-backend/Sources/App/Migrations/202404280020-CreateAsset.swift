import Fluent
import FluentPostgresDriver

extension Asset {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(Asset.schema).id().field(
                "user_id",
                .uuid,
                .required,
                .references("users", "id")
            )
            .field("value", .double, .required)

            .field("description", .string, .required)

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
        }

        func revert(on database: Database) async throws {
            try await database.schema(Asset.schema).delete()
        }
    }
}
