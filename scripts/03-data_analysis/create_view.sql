CREATE OR REPLACE VIEW public.daily_stock_returns AS
WITH trade_table_with_previous_return AS (
	SELECT sp.ticker,
		   sp.trade_date,
		   sr.company_name,
		   sr.sector,
		   sp.close AS close_price,
		   LAG(sp.close, 1) OVER (PARTITION BY sp.ticker ORDER BY trade_date) AS previous_close,
		   v.vix_close
	FROM stock_prices AS sp
	LEFT JOIN stock_reference AS sr
	ON sp.ticker = sr.ticker
	LEFT JOIN vix_daily AS v
	ON sp.trade_date = v.observation_date
	-- the date range was obtained from obtain_date_range.sql
	WHERE sp.trade_date >= '2010-06-28' AND sp.trade_date <= '2026-10-08'
)
SELECT ticker,
	   trade_date,
	   company_name,
	   sector,
	   close_price,
	   previous_close,
	   (close_price - previous_close)/NULLIF(previous_close,0) AS daily_return,
	   vix_close
FROM trade_table_with_previous_return
WHERE trade_date > '2010-06-28' -- remove the first date with null value because of missing previous close

-- in a subsequent check for data quality, it reveals that somehow SPY and TESLA are missing data on 2011-02-17. Confirmed that the data was missing from Stooq too. Nothing was done, since the data from one date shouldn't affect the general conclusion.