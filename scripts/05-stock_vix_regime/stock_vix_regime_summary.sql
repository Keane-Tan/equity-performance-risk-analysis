WITH vix_in_15yrs AS (
	SELECT *
	FROM vix_daily
	WHERE vix_daily IS NOT NULL AND observation_date >= '2011-10-08' AND observation_date <= '2026-10-08'
),
vix_regime_thresholds AS (
	SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY vix_close) AS low_vix,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY vix_close) AS high_vix
	FROM vix_in_15yrs
),
vix_regimes AS (
	SELECT *,
		CASE 
			WHEN vix_close <= (SELECT low_vix FROM vix_regime_thresholds) THEN 'low_vix'
			WHEN vix_close > (SELECT low_vix FROM vix_regime_thresholds) AND vix_close < (SELECT high_vix FROM vix_regime_thresholds) THEN 'moderate_vix'
			WHEN vix_close >= (SELECT high_vix FROM vix_regime_thresholds) THEN 'high_vix'
			ELSE 'high_vix' END AS vix_regime
	FROM
		vix_in_15yrs
),
daily_returns_in_15yrs AS (
	SELECT *,
		CASE
			WHEN daily_return < 0 THEN 1
			ELSE 0 END AS negative_day
	FROM daily_stock_returns
	WHERE trade_date >= '2011-10-08' AND trade_date <= '2026-10-08'
),
spy_returns_in_15yrs AS (
	SELECT trade_date,
		   daily_return
	FROM daily_returns_in_15yrs
	WHERE ticker = 'SPY'
),
returns_joined_vix_table AS (
	SELECT dr.ticker,
		dr.sector,
		dr.trade_date,
		vr.vix_regime,
		dr.daily_return,
		sr.daily_return AS spy_daily,
		dr.daily_return - sr.daily_return AS daily_excess,
		dr.negative_day
	FROM daily_returns_in_15yrs AS dr
	LEFT JOIN spy_returns_in_15yrs AS sr
	ON dr.trade_date = sr.trade_date
	LEFT JOIN vix_regimes AS vr
	ON dr.trade_date = vr.observation_date
)
SELECT ticker,
	   MAX(sector) AS sector,
	   vix_regime,
	   COUNT(*) AS observation_count,
	   AVG(daily_return) AS avg_daily_return,
	   STDDEV_SAMP(daily_return) AS daily_volatility,
	   SUM(negative_day)/COUNT(negative_day)::numeric AS negative_day_pct,
	   AVG(daily_excess) AS avg_excess_return_spy,
	   RANK() OVER (PARTITION BY vix_regime ORDER BY AVG(daily_excess) DESC) AS performance_rank
FROM returns_joined_vix_table
GROUP BY ticker, vix_regime
ORDER BY ticker,
	CASE vix_regime
	WHEN 'low_vix' THEN 1
	WHEN 'moderate_vix' THEN 2
	WHEN 'high_vix' THEN 3
	END;
