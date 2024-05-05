import Fluent
import FluentPostgresDriver

extension Goal {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(Goal.schema)
                .field(
                    "id",
                    .uuid,
                    .identifier(auto: false),
                    .required,
                    .sql(.default(SQLFunction("uuid_generate_v4")))
                )
                .field("name", .string, .required)
                .field("amount", .double, .required)
                .field(
                    "target_date",
                    .datetime,
                    .required
                )
                .field("user_id", .uuid, .required, .references("users", "id"))
                .field(
                    "progress",
                    .double,
                    .required,
                    .sql(.default(0))
                )
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
                .create(index: "\(Goal.schema)_user_id_index")
                .on(Goal.schema)
                .column("user_id")
                .run()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Goal.schema).delete()
        }
    }
}
