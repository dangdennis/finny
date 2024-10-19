-- last 12 months. optionally can exclude current month
WITH net_transfer_transactions AS (
	SELECT
		t1.id AS t1_id,
		t2.id AS t2_id
	FROM
		transactions t1
		JOIN transactions t2 ON - t2.amount = t1.amount
			AND t2.account_id != t1.account_id
			AND abs(extract(DAY FROM t1.date::timestamp - t2.date::timestamp)) <= 2
			AND t2.category = 'TRANSFER_IN'
	WHERE
		t1.amount > 0
		AND t1.category = 'TRANSFER_OUT'
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
		AND category NOT IN ('TRANSFER_IN', 'TRANSFER_OUT')
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
			-- Exclude transactions from net_transfer_transactions
			SELECT
				t1_id FROM net_transfer_transactions
			UNION
			SELECT
				t2_id FROM net_transfer_transactions)
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
	JOIN monthly_transfer_transactions mtt ON mrt.month = mtt.month
