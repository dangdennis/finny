import Fluent
import FluentPostgresDriver

extension Goal {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(Goal.schema).id().field("name", .string, .required)
                .field("amount", .double, .required).field(
                    "target_date",
                    .datetime,
                    .required
                ).field("user_id", .uuid, .required, .references("users", "id")).field(
                    "progress",
                    .double,
                    .required,
                    .sql(.default(0))
                ).field(
                    "created_at",
                    .datetime,
                    .required,
                    .sql(.default(SQLFunction("now")))
                ).field(
                    "updated_at",
                    .datetime,
                    .required,
                    .sql(.default(SQLFunction("now")))
                ).field("deleted_at", .datetime).create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Goal.schema).delete()
        }
    }
}
