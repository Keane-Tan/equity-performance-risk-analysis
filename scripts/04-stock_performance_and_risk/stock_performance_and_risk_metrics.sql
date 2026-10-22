CREATE OR REPLACE VIEW public.stock_performance_summary AS
-- limit the analysis to 15 years, also skipped the problematic date 2011-02-17
WITH data_in_15_year AS (
	SELECT *,
	FIRST_VALUE(close_price) OVER (PARTITION BY ticker ORDER BY trade_date ASC) AS earliest_price,
	FIRST_VALUE(close_price) OVER (PARTITION BY ticker ORDER BY trade_date DESC) AS latest_price,
	MAX(close_price) OVER (PARTITION BY ticker ORDER BY trade_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_max_price --running maximum
	FROM daily_stock_returns
	WHERE trade_date >= '2011-10-08' AND trade_date <= '2026-10-08'
),
data_with_metrics AS (
	SELECT ticker, 
		   MAX(sector) AS sector,
		   MAX(company_name) AS company_name,
		   MAX(latest_price)/NULLIF(MAX(earliest_price),0) - 1 AS cumulative_return, -- MAX() is just a trick to bypass the GROUP BY requirement
		   MIN(daily_return) AS largest_negative_daily_return,
		   MAX(daily_return) AS largest_positive_daily_return,
		   AVG(daily_return) AS avg_daily_return,
		   STDDEV_SAMP(daily_return)*SQRT(252) AS annualized_volatility,
		   PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY daily_return) AS fifth_percentile_return,
		   MIN(close_price/running_max_price - 1) AS max_drawdown
	FROM data_in_15_year
	GROUP BY ticker
)
SELECT ticker,
	   company_name,
	   sector,
	   cumulative_return,
	   cumulative_return - (SELECT cumulative_return FROM data_with_metrics WHERE ticker = 'SPY') AS excess_return_over_SPY,
	   largest_negative_daily_return,
	   largest_positive_daily_return,
	   avg_daily_return,
	   annualized_volatility,
	   fifth_percentile_return,
	   max_drawdown,
	   RANK() OVER (ORDER BY cumulative_return DESC) AS performance_rank,
	   RANK() OVER (ORDER BY annualized_volatility DESC) AS volatility_rank,
	   RANK() OVER (ORDER BY fifth_percentile_return) AS p5_return_rank
FROM data_with_metrics
;