CREATE TABLE ynab_raw (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    categories_json jsonb,
    user_id uuid NOT NULL REFERENCES profiles(id) UNIQUE,
    categories_last_knowledge_of_server integer,
    categories_last_updated timestamp
);
