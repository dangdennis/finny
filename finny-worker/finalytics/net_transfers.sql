-- get all net transfers
SELECT
	t1.id,
	t1.name,
	t1.amount,
	t1.date,
	t2.id,
	t2.name,
	t2.amount,
	t2.date
FROM
	transactions t1
	JOIN transactions t2 ON - t2.amount = t1.amount
		AND t2.account_id <> t1.account_id
		AND abs(extract(days FROM t1.date::timestamp - t2.date::timestamp)) <= 2
        AND t2.category = 'TRANSFER_IN'
WHERE
	t1.amount > 0
    AND t1.category = 'TRANSFER_OUT'
ORDER BY
    t1.date desc;

-- get all net transfers in a given month
SELECT
	t1.id,
	t1.name,
	t1.amount,
	t1.date,
	t2.id,
	t2.name,
	t2.amount,
	t2.date
FROM
	transactions t1
	JOIN transactions t2 ON - t2.amount = t1.amount
		AND t2.account_id <> t1.account_id
		AND abs(extract(days FROM t1.date::timestamp - t2.date::timestamp)) <= 2
        AND t2.category = 'TRANSFER_IN'
WHERE
	t1.amount > 0
    AND t1.category = 'TRANSFER_OUT'
	AND t1.date BETWEEN '{{current_month}}'::date AND (
		SELECT
			(date_trunc('month', '{{current_month}}'::date) + INTERVAL '1 month' - INTERVAL '1 day')::date)
ORDER BY
    t1.date desc;

--
-- Get all net transfers from the last 12 months, excluding the current month
SELECT
	t1.id,
	t1.name,
	t1.amount,
	t1.date,
	t2.id,
	t2.name,
	t2.amount,
	t2.date
FROM
	transactions t1
	JOIN transactions t2 ON - t2.amount = t1.amount
		AND t2.account_id <> t1.account_id
		AND ABS(EXTRACT(DAY FROM t1.date::timestamp - t2.date::timestamp)) <= 2
        AND t2.category = 'TRANSFER_IN'
WHERE
	t1.amount > 0
    AND t1.category = 'TRANSFER_OUT'
	AND t1.date BETWEEN (
		SELECT (date_trunc('month', current_date) - INTERVAL '12 months')::date -- Start date: 12 months ago
	) AND (
		SELECT (date_trunc('month', current_date) - INTERVAL '1 day')::date -- End date: last day of the previous month
	)
ORDER BY
    t1.date desc;
