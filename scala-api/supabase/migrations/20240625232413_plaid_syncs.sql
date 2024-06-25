
create table if not exists plaid_syncs(
    id uuid primary key default gen_random_uuid(),
    date_effective date not null,
    status text not null
);