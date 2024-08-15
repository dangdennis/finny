alter table goal_accounts add constraint unique_goal_accounts_goal_id_and_account_id unique (goal_id, account_id);
