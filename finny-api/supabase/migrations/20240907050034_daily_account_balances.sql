CREATE TABLE IF NOT EXISTS account_balances (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    account_id uuid NOT NULL REFERENCES accounts(id),
    balance_date date NOT NULL,
    current_balance double precision NOT NULL,
    available_balance double precision,
    created_at timestamp(6) with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

SELECT cron.schedule('four_hour_account_balance_job', '0 */4 * * *',  -- Runs every 4 hours
    $$INSERT INTO account_balances (account_id, balance_date, current_balance, available_balance)
      SELECT id, CURRENT_DATE, current_balance, available_balance
      FROM accounts
      WHERE deleted_at IS NULL
      AND NOT EXISTS (
          SELECT 1
          FROM account_balances
          WHERE account_balances.account_id = accounts.id
          AND account_balances.balance_date = CURRENT_DATE
      );$$
);
