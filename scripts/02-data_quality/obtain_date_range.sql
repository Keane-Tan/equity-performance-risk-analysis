-- getting the date range
SELECT MAX(min_date) AS min_date, MIN(max_date) AS max_date
FROM (
	-- getting the latest earliest trade date and the earliest latest trade date
	SELECT MAX(min_date) AS min_date, MIN(max_date) AS max_date
	FROM (
	-- getting earliest and latest trade date of each stock
		SELECT ticker, MIN(trade_date) AS min_date, MAX(trade_date) AS max_date
		FROM stock_prices
		GROUP BY ticker
	)
	UNION ALL
	-- getting earliest and latest record date of VIX
	SELECT MIN(observation_date) AS min_date, MAX(observation_date) AS max_date
	FROM vix_daily
);

-- Running this query shows 2010-06-28 to 2026-10-08 should contain data for all the stocks