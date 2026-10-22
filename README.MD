# Equity Performance & Market Risk Analysis

**PostgreSQL | Advanced SQL | Tableau Public | Investment Analytics**

An independent analysis of the historical performance and risk characteristics of **15 U.S. stocks**, using **SPY** as a broad-market ETF benchmark and the **Cboe Volatility Index (VIX)** to compare stock behavior across market-volatility regimes. The project covers approximately **15 years of daily market data**.

### [View the interactive Tableau dashboard](https://public.tableau.com/app/profile/keane.tan7245/viz/EquityPerformanceMarketRiskAnalysis/Dashboard1)

The calculations and data preparation were performed in PostgreSQL; Tableau is used to present and explore the results.

## Questions explored

- Which stocks delivered the strongest cumulative price returns relative to SPY?
- How did historical returns compare with annualized volatility, downside-return percentiles, and maximum drawdown?
- Which stocks tended to outperform or underperform SPY on days with low, moderate, or high VIX levels?

## Tools and SQL techniques

- **PostgreSQL / pgAdmin 4:** relational tables, data preparation, validation, analytical views, and query execution.
- **Advanced SQL:** common table expressions (CTEs), joins, window functions (`LAG`, running `MAX`, ranking), conditional aggregation, and ordered-set aggregates (`PERCENTILE_CONT`).
- **Tableau Public:** interactive presentation of return, risk, and volatility-regime comparisons.
- **Git / GitHub:** version control and project documentation.

## Data sources

| Dataset | Source | Purpose |
| --- | --- | --- |
| Historical OHLCV data for 15 U.S. stocks and SPY | [Stooq](https://stooq.com/) | Daily prices, returns, and price-based risk metrics |
| `VIXCLS` | [FRED, Federal Reserve Bank of St. Louis](https://fred.stlouisfed.org/series/VIXCLS) | Historical VIX observations for volatility-regime classification |
| S&P 500 constituent metadata | [Wikipedia](https://en.wikipedia.org/wiki/List_of_S%26P_500_companies) | Company names and GICS sector classifications |

**Stock universe:** AAPL, AMZN, CAT, GOOGL, JNJ, JPM, KO, MSFT, NEE, NVDA, PLD, TSLA, UNH, WMT, and XOM. **Benchmark:** SPY.

The stock universe was selected for this retrospective analysis; it is **not** a historically reconstituted S&P 500 portfolio or a tested stock-selection strategy.

## Analytical workflow

### 1. Data preparation and validation

Import historical prices, VIX observations, and company reference data into PostgreSQL. Standardize tickers and date fields; check primary-key uniqueness, duplicate ticker/date combinations, invalid or missing prices, date coverage, and unmatched join records. Preserve missing source observations rather than creating artificial prices.

### 2. Stock performance and risk

Use SQL analytical views to calculate:

| Metric | Definition |
| --- | --- |
| Daily price return | Current close / previous available close − 1 |
| Cumulative price return | Ending close / starting close − 1 over the selected period |
| Annualized volatility | Sample standard deviation of daily returns × √252 |
| 5th-percentile daily return | Empirical lower-tail return percentile |
| Maximum drawdown | Worst percentage decline from a previous running closing-price peak |
| Excess cumulative return vs. SPY | Stock cumulative return − SPY cumulative return over common endpoints |
| Performance ranking | Relative rankings of the selected securities |

### 3. VIX market-regime analysis

Classify valid daily VIX observations using their 25th and 75th percentiles over the study period:

- **Low VIX:** At or below the 25th percentile.
- **Moderate VIX:** Between the 25th and 75th percentiles.
- **High VIX:** At or above the 75th percentile.

Within each regime, summarize average daily returns, daily-return volatility, the percentage of negative-return days, and **average daily excess return versus SPY**. These are descriptive, contemporaneous comparisons—not predictions of future returns.

## Key Findings

The analysis covers 15 selected U.S. equities and the SPY benchmark over approximately 15 years. The findings below describe historical relationships within this sample, rather than investment recommendations.

### 1. Market-volatility conditions substantially changed relative performance

NVDA and TSLA recorded the highest average daily excess returns versus SPY during low-VIX conditions, at **+0.25 and +0.24 percentage points**, respectively. During high-VIX conditions, those figures fell to **−0.02 and −0.09 percentage points**.

This suggests that strong performance relative to the benchmark in calmer market environments did not necessarily persist when implied market volatility was elevated.

### 2. Several stocks demonstrated stronger benchmark-relative resilience during high-VIX periods

WMT, NEE, and XOM each recorded approximately **+0.12 percentage points** of average daily excess return versus SPY during high-VIX periods. UNH (+0.10 percentage points) and JNJ (+0.09 percentage points) also outperformed on average.

These results highlight differences in historical market-regime sensitivity among the selected securities. Positive excess returns indicate relative outperformance, not necessarily positive absolute stock returns.

### 3. Some securities exhibited pronounced changes in relative performance across regimes

XOM's average daily excess return shifted from **−0.12 percentage points in low-VIX conditions to +0.12 percentage points in high-VIX conditions**. Similar improvements appeared for WMT (−0.07 to +0.12 percentage points) and NEE (−0.08 to +0.12 percentage points).

These changes suggest that relative stock performance was sensitive to the prevailing market-volatility environment, although the analysis does not establish causality.

### 4. High-VIX periods did not produce uniform underperformance

Of the 15 individual stocks, **nine displayed positive average daily excess returns versus SPY** during high-VIX periods, while five displayed negative values and one was approximately zero at the dashboard's displayed precision.

This emphasizes the importance of comparing individual securities against a common benchmark rather than assuming all stocks behave similarly during market stress.

### 5. Long-term performance should be considered alongside investment risk

The Tableau risk-versus-return visualization shows substantial differences in cumulative performance and annualized volatility across the selected equities. The complementary maximum-drawdown calculation captures downside exposure that standard deviation alone cannot fully describe.

Together, these metrics provide a broader perspective on historical performance than cumulative return rankings alone.

### Interpretation and Limitations

VIX regimes were defined retrospectively using the 25th and 75th percentiles of historical VIX observations. Reported excess returns represent differences between stock and SPY **average daily returns**, measured in percentage points; they are not cumulative returns or predictive estimates. The stock universe was selected retrospectively, and price-data limitations may affect individual metrics.

[Explore the interactive Tableau dashboard](https://public.tableau.com/app/profile/keane.tan7245/viz/EquityPerformanceMarketRiskAnalysis/Dashboard1) | [View the analysis results on GitHub](https://github.com/Keane-Tan/equity-performance-risk-analysis/tree/main/results)

## Interactive dashboard

**[Open the Tableau Public dashboard →](https://public.tableau.com/app/profile/keane.tan7245/viz/EquityPerformanceMarketRiskAnalysis/Dashboard1)**

The dashboard is intended to make the PostgreSQL outputs easier to compare visually, including:

- **Risk versus return:** stock performance in relation to annualized volatility and maximum drawdown.
- **VIX regime comparison:** how benchmark-relative daily returns differ across market-volatility conditions.

The Tableau visualization is a presentation layer; the investment metrics are calculated in SQL.

## Repository and setup

The repository contains the project's SQL/setup scripts, documentation, and exported results. The setup files include:

- `scripts/01-setup/create_combined_table.sql` — combines imported stock price histories.
- `scripts/01-setup/create_vix_table.sql` — defines the VIX table.
- `scripts/01-setup/create_sp500_stock_info_table.sql` — defines the company metadata table.
- `scripts/01-setup/import_wikipedia_table.py` — optional helper to retrieve the Wikipedia reference table.
- `scripts/01-setup/load_stocks.ps1` — PowerShell CSV-loading helper for a locally configured PostgreSQL installation.

To reproduce the workflow:

1. Install PostgreSQL and pgAdmin 4, then create a database named `stock_market_project` (or adjust script references to another name).
2. Obtain historical stock, VIX, and company metadata files from the data sources above.
3. Run the relevant table-creation/import scripts in `scripts/01-setup/`, adjusting local file paths and connection settings as needed. The PowerShell helper assumes a Windows PostgreSQL installation; it may require adaptation on other systems.
4. Run the project's analytical SQL queries/views and verify the data-quality checks before interpreting results.
5. Export the performance and VIX regime summaries as CSV files and use them in Tableau.

**Security:** Use your own local PostgreSQL credentials. Do not commit passwords, tokens, or other secrets to this public repository.

## Limitations

- **Price-based analysis:** Closing-price calculations should not be interpreted as dividend-reinvested total returns unless the source adjustments and methodology have been independently validated.
- **Historical selection bias:** The basket consists of securities chosen retrospectively; the Wikipedia constituent list is a current reference, not point-in-time index membership.
- **Data gaps:** Some otherwise valid trading days may be absent for particular tickers. Consecutive-available-observation returns can occasionally span more than one trading session, affecting daily-risk and same-date benchmark comparisons.
- **Drawdown measurement:** Maximum drawdown is based on observed closing prices, not intraday prices or a dividend-reinvested wealth index.
- **VIX interpretation:** The VIX is an implied-volatility measure. Historical same-day associations with stock returns do not establish causation or predictive performance.

## Potential extensions

Rolling volatility and correlation analysis, sector-level comparisons, more systematic completeness tests, and additional benchmark-relative risk measures.

---

*Independent educational portfolio project. Not investment advice.*
