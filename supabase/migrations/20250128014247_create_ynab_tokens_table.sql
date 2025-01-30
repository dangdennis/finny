-- Create ynab_tokens table
CREATE TABLE IF NOT EXISTS ynab_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    access_token TEXT NOT NULL,
    refresh_token TEXT NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index on user_id for faster lookups
CREATE INDEX idx_ynab_tokens_user_id ON ynab_tokens(user_id);

-- Add RLS (Row Level Security) policies
ALTER TABLE ynab_tokens ENABLE ROW LEVEL SECURITY;

-- Users can only see their own tokens
CREATE POLICY "Users can view their own tokens"
    ON ynab_tokens FOR SELECT
    USING (auth.uid() = user_id);

-- Users can only insert their own tokens
CREATE POLICY "Users can insert their own tokens"
    ON ynab_tokens FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Users can only update their own tokens
CREATE POLICY "Users can update their own tokens"
    ON ynab_tokens FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);