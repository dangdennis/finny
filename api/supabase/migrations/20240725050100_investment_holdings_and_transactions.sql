alter table plaid_items add columns
    error_type text,
    error_code text,
    error_message text,
    error_display_message text,
    error_request_id text,
    documentation_url text,
    suggested_action text;

create table if not exists investment_transactions (
    id uuid primary key default gen_random_uuid()
);

create table if not exists investment_holdings (
    id uuid primary key default gen_random_uuid()
);

create table if not exists investment_securities (
    id uuid primary key default gen_random_uuid()
);
