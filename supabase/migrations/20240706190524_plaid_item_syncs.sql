ALTER TABLE
    plaid_items
ADD
    COLUMN last_synced_at timestamp with time zone,
ADD
    COLUMN last_sync_error text,
ADD
    COLUMN last_sync_error_at timestamp with time zone,
ADD
    COLUMN retry_count integer DEFAULT 0;