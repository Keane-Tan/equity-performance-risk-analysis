# Project Overview
This project uses PostgreSQL to analyze the historical performance and risk characteristics of 15 U.S. equities relative to the SPY ETF benchmark over a 15-year period.

Historical stock prices were obtained from Stooq, with S&P 500 constituent information sourced from Wikipedia (more details in [Sources of Tables](#sources-of-tables)).

The analysis demonstrates relational database design, data validation, common table expressions (CTEs), window functions, statistical aggregation, and benchmark comparisons.

# Key Analyses
- Historical daily and cumulative stock returns
- Annualized return volatility
- Downside risk using fifth-percentile daily returns
- Benchmark-relative performance against SPY
- Stock performance rankings

# Limitations and Future Work
The analysis focuses on historical price-based performance and is subject to data-source limitations, occasional missing observations, and selection bias from the chosen securities.

Future extensions may include VIX-based market regime analysis, rolling volatility, maximum drawdown, and sector-level comparisons.

# Sources of Tables
The tables used in this project are
- Historical data of 15 stocks from different industries and SPY from https://stooq.com/
  - The 15 stocks are: AAPL, AMZN, CAT, GOOGL, JNJ, JPM, KO, MSFT, NEE, NVDA, PLD, TSLA, UNH, WMT, XOM
- VIX data (`vixcls`) taken from https://fred.stlouisfed.org/
- Information of the stocks in S&P 500 taken from https://en.wikipedia.org/wiki/List_of_S%26P_500_companies
  - If you are comfortable with `python`, you may run `scripts/01-setup/import_wikipedia_table.py` to obtain the table in the `csv` format.


# Setup
The project was performed using PostgreSQL through pgAdmin4, which can be downloaded: https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

Remember the password used during the installation. It will be used as the argument for `PGPASSWORD` in the `scripts/01-setup/load_stocks.ps1` file.

## Create a database in pgAdmin4
1. In the Object Explorer panel on the left, expand PostgreSQL 18 (or the version you're using), right click on Databases, click Create -> Database...
2. Name the Database `stock_market_project`, leave other parameters at their default values, and click Save.

### Loading the historical data of the 15 stocks and SPY
1. Copy `scripts/01-setup/load_stocks.ps1` to the folder that contains the historical data tables for the 15 stocks and SPY.
1. Modify the argument for `PGPASSWORD` from `XXXX` to your password for PostgreSQL.
1. If you're doing this project on Windows 10/11, use powershell to navigate to the directory where the 16 tables (15 stocks + SPY) are stored and run the script using the command below: `./load_stocks.ps1`. (Modify `load_stocks.ps1` as needed if running on other OS.)
1. In `pgAdmin4`, right click on `Databases -> stock_market_project` and select `Query Tool`.
1. Open `scripts/01-setup/create_combined_table.sql` and run it. This creates a table called `stock_prices` in `stock_market_project->Schemas->public->Tables` that has all the price history information of the 15 stocks and SPY.

### Loading the VIX table
1. In `pgAdmin4`, right click on `Databases -> stock_market_project` and select `Query Tool`.
1. Open `scripts/01-setup/create_vix_table.sql` and run it. This creates a table called `vix_daily` in `stock_market_project->Schemas->public->Tables`. If you do not see the table, right click on `Tables` and select `Refresh`.
1. Right click on `vix_daily` and select `Import/Export data`.
   - Under `General`
      - Select `Import`
      - `Filename` should point to the vix csv file.
      - `Format`: csv
      - `Encoding`: UTF8
   - Under `Options`
      - Toggle `Header` on.

### Loading the table containing information on the S&P500 stocks
The steps are exactly the same as the steps for loading the VIX table. Replace `scripts/01-setup/create_vix_table.sql` to `scripts/01-setup/create_sp500_stock_info_table.sql` and make sure `Filename` points to the S&P500 stocks information table.
