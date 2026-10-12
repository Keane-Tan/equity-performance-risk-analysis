CREATE TABLE sp500_stock_info (
	ticker TEXT PRIMARY KEY,
	security TEXT,
	gics_sector TEXT,
	gics_sub_industry TEXT,
	headquarters_location TEXT,
	date_added DATE,
	cik TEXT,
	founded TEXT
)