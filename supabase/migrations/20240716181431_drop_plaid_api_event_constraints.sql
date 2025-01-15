drop table if exists public.jobs;

DO $$ 
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = 'plaid_api_events_item_id_fkey'
    ) THEN
        ALTER TABLE plaid_api_events
        DROP CONSTRAINT plaid_api_events_item_id_fkey;
    END IF;
END $$;

DO $$ 
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = 'plaid_api_events_user_id_fkey'
    ) THEN
        ALTER TABLE plaid_api_events
        DROP CONSTRAINT plaid_api_events_user_id_fkey;
    END IF;
END $$;
