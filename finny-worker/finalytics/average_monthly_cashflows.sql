-- last 12 months. optionally can exclude current month
-- this query does not account for multitenancy yet. it will require
-- a join to the plaid items table with user id.

WITH net_transfer_and_creditcard_payment_transactions AS (
	SELECT
		t1.id AS t1_id,
		t2.id AS t2_id
	FROM
		transactions t1
		JOIN transactions t2 ON -t2.amount = t1.amount
			AND t2.account_id != t1.account_id
			AND abs(extract(DAY FROM t1.date::timestamp - t2.date::timestamp)) <= 3
			-- Credit card payments are recorded as a pair of transactions:
			-- a withdrawal (debit) from the checking account labeled as LOAN_PAYMENTS, and a corresponding deposit
			-- (credit) to the credit card account labeled as TRANSFER_IN or LOAN_PAYMENTS.
			-- For some banks like Wells Fargo/Bilt, they strangely record the credit transaction under TRANSFER_IN,
			AND (t2.category = 'LOAN_PAYMENTS' or t2.category = 'TRANSFER_IN')
	WHERE
		t1.amount > 0
		-- Certain banks like Wells Fargo and Bilt
		AND (t1.category = 'LOAN_PAYMENTS' or t1.category = 'TRANSFER_OUT')
		AND t1.date >= (date_trunc('month', CURRENT_DATE) - INTERVAL '12 months')
		--		AND t1.date < date_trunc('month', CURRENT_DATE)
	ORDER BY
		t1.date DESC
),
monthly_regular_transactions AS (
	SELECT
		date_trunc('month', date) AS month,
	sum(
		CASE WHEN amount < 0 THEN
			abs(amount)
		ELSE
			0
		END) AS monthly_inflows,
	sum(
		CASE WHEN amount > 0 THEN
			amount
		ELSE
			0
		END) AS monthly_outflows
FROM
	transactions
	JOIN accounts ON transactions.account_id = accounts.id
	WHERE
		date >= (date_trunc('month', CURRENT_DATE) - INTERVAL '12 months')
		--		AND date < date_trunc('month', CURRENT_DATE)
		-- Exclude transfers
		AND category NOT IN ('TRANSFER_IN', 'TRANSFER_OUT', 'LOAN_PAYMENTS')
		-- Exclude credit card payments, but continue to include "personal" loan payments like to Paypal, Affirm, BNPY-type schemes
		AND subcategory != 'LOAN_PAYMENTS_CREDIT_CARD_PAYMENT'
	GROUP BY
		date_trunc('month', date)
	ORDER BY
		month
),
monthly_transfer_transactions AS (
	SELECT
		date_trunc('month', date) AS month,
		sum(
			CASE WHEN category = 'TRANSFER_IN' THEN
				abs(amount)
			ELSE
				0
			END) AS monthly_inflows,
		sum(
			CASE WHEN category = 'TRANSFER_OUT' THEN
				abs(amount)
			ELSE
				0
			END) AS monthly_outflows
	FROM
		transactions
	WHERE
		date >= (date_trunc('month', CURRENT_DATE) - INTERVAL '12 months')
		--		AND date < date_trunc('month', CURRENT_DATE)
		AND category IN ('TRANSFER_IN', 'TRANSFER_OUT')
		AND transactions.id NOT IN (
			-- Exclude net transfer transactions
			SELECT
				t1_id FROM net_transfer_and_creditcard_payment_transactions
			UNION
			SELECT
				t2_id FROM net_transfer_and_creditcard_payment_transactions)
	GROUP BY
		date_trunc('month', date)
	ORDER BY
		month DESC
)
SELECT
  avg(mrt.monthly_inflows + mtt.monthly_inflows) AS monthly_inflows,
  avg(mrt.monthly_outflows + mtt.monthly_outflows) AS monthly_outflows
FROM
	monthly_regular_transactions mrt
	JOIN monthly_transfer_transactions mtt ON mrt.month = mtt.month;
