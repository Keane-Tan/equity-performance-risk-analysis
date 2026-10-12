-- make sure data is complete, consistent, and suitable for analysis

-- check for duplicates in the record, making sure each combination of ticker and trade_date is unique
-- no NULL value for closing price
-- no non-positive value for closing price
WITH prices_duplicate_count AS (
	SELECT *, 
		   COUNT(*) OVER(PARTITION BY ticker, trade_date) AS duplicate_count
	FROM stock_prices
)
SELECT *
FROM prices_duplicate_count
WHERE duplicate_count > 1 OR 
	  close IS NULL OR
	  close <= 0;