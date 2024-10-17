CREATE TABLE ynab_raw (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    categories_json jsonb,
    user_id uuid NOT NULL REFERENCES profiles(id) UNIQUE
);
