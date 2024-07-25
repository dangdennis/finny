ALTER TABLE plaid_items
	ADD columns error_type text, error_code text, error_message text, error_display_message text, error_request_id text, documentation_url text, suggested_action text;

CREATE TABLE IF NOT EXISTS investment_transactions (
	id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
	plaid_investment_transaction_id varchar NOT NULL UNIQUE,
	account_id uuid NOT NULL REFERENCES accounts (id),
	investment_security_id uuid NOT NULL REFERENCES investment_securities (id),
	date timestamptz NOT NULL,
	name varchar NOT NULL,
	quantity double precision NOT NULL,
	amount double precision NOT NULL,
	price double precision NOT NULL,
	fees double precision,
	investment_transaction_type varchar NOT NULL,
	iso_currency_code varchar,
	unofficial_currency_code varchar,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	deleted_at timestamptz
);

CREATE INDEX ix:investment_transactions.plaid_investment_transaction_id ON investment_transactions(plaid_investment_transaction_id);
CREATE INDEX ix:investment_transactions.account_id ON investment_transactions(account_id);
CREATE INDEX ix:investment_transactions.investment_security_id ON investment_transactions(investment_security_id);


CREATE TABLE IF NOT EXISTS investment_holdings (
	id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
	account_id uuid NOT NULL REFERENCES accounts (id),
	security_id varchar NOT NULL REFERENCES investment_securities (id),
	institution_price double precision NOT NULL,
	institution_price_as_of timestamptz,
	institution_price_date_time timestamptz,
	institution_value double precision NOT NULL,
	cost_basis double precision,
	quantity double precision NOT NULL,
	iso_currency_code varchar,
	unofficial_currency_code varchar,
	vested_value double precision,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	deleted_at timestamptz
);

CREATE INDEX ix:investment_holdings.account_id ON investment_holdings(account_id);
CREATE INDEX ix:investment_holdings.security_id ON investment_holdings(security_id);

CREATE TABLE IF NOT EXISTS investment_securities (
	id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
	plaid_security_id varchar NOT NULL,
	plaid_institution_security_id varchar,
	plaid_institution_id varchar,
	plaid_proxy_security_id varchar,
	name varchar,
	ticker_symbol varchar,
	security_type varchar,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	deleted_at timestamptz
);

CREATE INDEX ix:investment_securities.plaid_security_id ON investment_securities(plaid_security_id);
CREATE INDEX ix:investment_securities.plaid_institution_security_id ON investment_securities(plaid_institution_security_id);
CREATE INDEX ix:investment_securities.plaid_institution_id ON investment_securities(plaid_institution_id);
CREATE INDEX ix:investment_securities.plaid_proxy_security_id ON investment_securities(plaid_proxy_security_id);
