-- Drop the policies
DROP POLICY IF EXISTS "Users can view their own tokens" ON ynab_tokens;

DROP POLICY IF EXISTS "Users can insert their own tokens" ON ynab_tokens;

DROP POLICY IF EXISTS "Users can update their own tokens" ON ynab_tokens;

-- Disable RLS
ALTER TABLE ynab_tokens DISABLE ROW LEVEL SECURITY;
