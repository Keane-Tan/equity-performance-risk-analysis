CREATE TABLE stock_prices (
	ticker	    text     NOT NULL,
	trade_date  date     NOT NULL,
	open 		numeric,
	high  		numeric,
	low  		numeric,
	close  		numeric,
	volume  	numeric,
	PRIMARY KEY (ticker, trade_date)
);

INSERT INTO stock_prices (ticker, trade_date, open, high, low, close, volume)
SELECT 'AMZN', Date, Open, High, Low, Close, Volume
FROM amzn_trading
UNION ALL
SELECT 'AAPL', Date, Open, High, Low, Close, Volume
FROM aapl_trading
UNION ALL
SELECT 'CAT', Date, Open, High, Low, Close, Volume
FROM cat_trading
UNION ALL
SELECT 'GOOGL', Date, Open, High, Low, Close, Volume
FROM googl_trading
UNION ALL
SELECT 'JNJ', Date, Open, High, Low, Close, Volume
FROM jnj_trading
UNION ALL
SELECT 'KO', Date, Open, High, Low, Close, Volume
FROM ko_trading
UNION ALL
SELECT 'MSFT', Date, Open, High, Low, Close, Volume
FROM msft_trading
UNION ALL
SELECT 'NEE', Date, Open, High, Low, Close, Volume
FROM nee_trading
UNION ALL
SELECT 'NVDA', Date, Open, High, Low, Close, Volume
FROM nvda_trading
UNION ALL
SELECT 'PLD', Date, Open, High, Low, Close, Volume
FROM pld_trading
UNION ALL
SELECT 'SPY', Date, Open, High, Low, Close, Volume
FROM spy_trading
UNION ALL
SELECT 'TSLA', Date, Open, High, Low, Close, Volume
FROM tsla_trading
UNION ALL
SELECT 'UNH', Date, Open, High, Low, Close, Volume
FROM unh_trading
UNION ALL
SELECT 'WMT', Date, Open, High, Low, Close, Volume
FROM wmt_trading
UNION ALL
SELECT 'XOM', Date, Open, High, Low, Close, Volume
FROM xom_trading;