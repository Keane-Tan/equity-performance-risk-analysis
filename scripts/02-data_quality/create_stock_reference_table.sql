CREATE TABLE stock_reference AS
SELECT DISTINCT s.ticker, spi.security AS company_name, spi.gics_sector AS sector, spi.gics_sub_industry AS sub_industry
FROM stock_prices AS s
LEFT JOIN sp500_stock_info AS spi
ON s.ticker = spi.ticker;

-- adding primary key
ALTER TABLE stock_reference
ADD PRIMARY KEY(ticker);

-- adding asset_type column
ALTER TABLE stock_reference
ADD asset_type VARCHAR(50);

-- set asset_type to ETF for SPY
UPDATE stock_reference
SET asset_type = 'etf'
WHERE ticker = 'SPY';

-- set asset_type to the remaining stocks
UPDATE stock_reference
SET asset_type = 'stock'
WHERE asset_type IS NULL;