import Fluent
import FluentPostgresDriver

extension PowerSync {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await (database as! SQLDatabase).raw(
                """
                -- Create publication for powersync
                create publication powersync for table 
                    public.\(unsafeRaw: Account.schema),
                    public.\(unsafeRaw: Asset.schema),
                    public.\(unsafeRaw: PlaidItem.schema),
                    public.\(unsafeRaw: Transaction.schema),
                    public.\(unsafeRaw: Goal.schema),
                    public.\(unsafeRaw: User.schema);
                """
            ).run()
        }

        func revert(on database: Database) async throws {
            try await (database as! SQLDatabase)
                .raw(
                    """
                    -- Drop publication for powersync
                    drop publication powersync;
                    """
                )
                .run()
        }
    }
}
