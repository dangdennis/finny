DO $$ 
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = 'plaid_link_events_user_id_fkey'
    ) THEN
        ALTER TABLE plaid_link_events
        DROP CONSTRAINT plaid_link_events_user_id_fkey;
    END IF;
END $$;

alter table profiles add column deleted_at timestamptz;