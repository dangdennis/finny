import Fluent
import FluentPostgresDriver

extension PowerSync {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await (database as! SQLDatabase).raw(
                """
                -- Create publication for powersync
                DO $$
                BEGIN
                    -- Check if the publication already exists
                    IF NOT EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'powersync') THEN
                        create publication if not exists powersync for table 
                            public.\(unsafeRaw: Account.schema),
                            public.\(unsafeRaw: Asset.schema),
                            public.\(unsafeRaw: PlaidItem.schema),
                            public.\(unsafeRaw: Transaction.schema),
                            public.\(unsafeRaw: Goal.schema),
                            public.\(unsafeRaw: User.schema);
                    END IF;
                END $$;
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
