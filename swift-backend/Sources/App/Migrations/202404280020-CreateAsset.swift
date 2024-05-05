import Fluent
import FluentPostgresDriver

extension Asset {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(Asset.schema)
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

            try await (database as! SQLDatabase)
                .create(index: "ix:\(Asset.schema).user_id")
                .on(Asset.schema)
                .column("user_id")
                .run()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Asset.schema).delete()
        }
    }
}
