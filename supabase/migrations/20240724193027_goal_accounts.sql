CREATE TABLE IF NOT EXISTS goal_accounts(
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  goal_id UUID NOT NULL REFERENCES goals(id),
  account_id UUID NOT NULL REFERENCES accounts(id),
  amount DECIMAL(10, 2) NOT NULL,
  percentage DECIMAL(5, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE INDEX ix_goal_accounts_goal_id ON goal_accounts(goal_id);
CREATE INDEX ix_goal_accounts_account_id ON goal_accounts(account_id);
