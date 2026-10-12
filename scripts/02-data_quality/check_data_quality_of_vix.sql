-- The following block of code is to obtain dates where no trading data exist based on SPY dataset, because of holidays and weekends
-- generate a complete date range between the SPY start trading date and last trading date
WITH spy_date AS (
	SELECT trade_date
	FROM stock_prices
	WHERE ticker = 'SPY'
),
complete_date_range AS(
	SELECT generate_series(
		   min_date::date,
		   max_date::date,
		   '1 day'::interval)::date AS calendar_date
	FROM (
	SELECT MIN(trade_date) AS min_date,
		   MAX(trade_date) AS max_date
	FROM spy_date
	)
),
-- from obtain_date_range.sql, we find that the date range is 2010-06-28 to 2026-10-08, where we have complete data for all the chosen stocks
data_date AS (
	SELECT calendar_date AS date
	FROM complete_date_range
	WHERE calendar_date >= '2010-06-28' AND calendar_date <= '2026-10-08'
		AND calendar_date IN (
			SELECT trade_date
			FROM spy_date
	)
),
vix_duplicate_count AS (
	SELECT *,
		   COUNT(*) OVER(PARTITION BY observation_date, vix_close) AS duplicate_count
	FROM vix_daily
)
-- checking to see in the valid date range, whether there is any duplicate record, vix_close is null or non-positive
SELECT *
FROM vix_duplicate_count
WHERE observation_date IN (SELECT date FROM data_date) AND (
	  duplicate_count > 1 OR
	  vix_close IS NULL OR
	  vix_close <= 0
);



