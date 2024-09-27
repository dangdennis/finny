CREATE TABLE IF NOT EXISTS investment_holdings_daily (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    account_id uuid NOT NULL REFERENCES accounts(id),
    investment_security_id uuid NOT NULL REFERENCES investment_securities(id),
    holding_date date NOT NULL,                -- The date for the daily snapshot
    quantity double precision NOT NULL,        -- Quantity held at the end of the day
    institution_price double precision NOT NULL, -- Price of the security at the end of the day
    institution_value double precision NOT NULL, -- Value of the holdings at the end of the day
    cost_basis double precision,               -- Optional, to track cost changes if needed
    created_at timestamp(6) with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

SELECT cron.schedule(
    'insert_daily_holdings',
    '0 */4 * * *',  -- every 4 hours
    $$ 
    INSERT INTO investment_holdings_daily (account_id, investment_security_id, holding_date, quantity, institution_price, institution_value, cost_basis)
    SELECT 
        ih.account_id,
        ih.investment_security_id,
        CURRENT_DATE AS holding_date,
        ih.quantity,
        ih.institution_price,
        ih.institution_value,
        ih.cost_basis
    FROM 
        investment_holdings ih
    WHERE 
        NOT EXISTS (
            SELECT 1 
            FROM investment_holdings_daily ihd 
            WHERE ihd.account_id = ih.account_id
              AND ihd.investment_security_id = ih.investment_security_id
              AND ihd.holding_date = CURRENT_DATE
        );
    $$
);