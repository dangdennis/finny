CREATE TABLE IF NOT EXISTS users (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE,
    password_hash TEXT,
    apple_sub TEXT UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);


CREATE TABLE IF NOT EXISTS plaid_items (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    plaid_access_token TEXT NOT NULL UNIQUE,
    plaid_item_id TEXT NOT NULL UNIQUE,
    plaid_institution_id TEXT NOT NULL,
    status TEXT NOT NULL,
    transactions_cursor TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS ix_plaid_items_user_id ON plaid_items(user_id);

CREATE TABLE IF NOT EXISTS accounts (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    item_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    plaid_account_id TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    mask TEXT,
    official_name TEXT,
    current_balance REAL NOT NULL DEFAULT 0,
    available_balance REAL NOT NULL DEFAULT 0,
    iso_currency_code TEXT,
    unofficial_currency_code TEXT,
    type TEXT,
    subtype TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES plaid_items(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS ix_accounts_user_id ON accounts(user_id);

CREATE TABLE IF NOT EXISTS assets (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    value REAL NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS ix_assets_user_id ON assets(user_id);

CREATE TABLE IF NOT EXISTS goals (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    amount REAL NOT NULL,
    target_date TIMESTAMP NOT NULL,
    user_id TEXT NOT NULL,
    progress REAL NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS ix_goals_user_id ON goals(user_id);

CREATE TABLE IF NOT EXISTS transactions (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    account_id TEXT NOT NULL,
    plaid_transaction_id TEXT NOT NULL UNIQUE,
    category TEXT,
    subcategory TEXT,
    type TEXT NOT NULL,
    name TEXT NOT NULL,
    amount REAL NOT NULL,
    iso_currency_code TEXT,
    unofficial_currency_code TEXT,
    date DATE NOT NULL,
    pending BOOLEAN NOT NULL,
    account_owner TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

CREATE INDEX IF NOT EXISTS ix_transactions_account_id ON transactions(account_id);

CREATE TABLE IF NOT EXISTS plaid_api_events (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    item_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    plaid_method TEXT NOT NULL,
    arguments TEXT,
    request_id TEXT UNIQUE,
    error_type TEXT,
    error_code TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES plaid_items(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS ix_plaid_api_events_item_id ON plaid_api_events(item_id);

CREATE TABLE IF NOT EXISTS plaid_link_events (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL,
    user_id TEXT NOT NULL,
    link_session_id TEXT,
    request_id TEXT UNIQUE,
    error_type TEXT,
    error_code TEXT,
    status TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS ix_plaid_link_events_user_id ON plaid_link_events(user_id);
