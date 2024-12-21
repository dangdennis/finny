WITH monthly_regular_transactions AS (
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
		date >= (CURRENT_DATE - INTERVAL '12 months')
		AND category NOT IN ('TRANSFER_IN', 'TRANSFER_OUT')
	GROUP BY
		date_trunc('month', date)
),
monthly_transfer_transactions AS (
	SELECT
		date_trunc('month', date) AS month,
		sum(
			CASE WHEN category = 'TRANSFER_IN' THEN
				amount
			ELSE
				- amount
			END) AS net_transfer
	FROM
		transactions
	WHERE
		date >= (CURRENT_DATE - INTERVAL '12 months')
		AND category IN ('TRANSFER_IN', 'TRANSFER_OUT')
	GROUP BY
		date_trunc('month', date)
),
adjusted_monthly_totals AS (
	SELECT
		mrt.month,
		CASE WHEN coalesce(mtt.net_transfer, 0) > 0 THEN
			mrt.monthly_inflows + coalesce(mtt.net_transfer, 0)
		ELSE
			mrt.monthly_inflows
		END AS adjusted_inflows,
		CASE WHEN coalesce(mtt.net_transfer, 0) < 0 THEN
			mrt.monthly_outflows - coalesce(mtt.net_transfer, 0)
		ELSE
			mrt.monthly_outflows
		END AS adjusted_outflows
	FROM
		monthly_regular_transactions mrt
		LEFT JOIN monthly_transfer_transactions mtt ON mrt.month = mtt.month
)
SELECT
	avg(adjusted_inflows) AS inflows,
	avg(adjusted_outflows) AS outflows
FROM
	adjusted_monthly_totals;
