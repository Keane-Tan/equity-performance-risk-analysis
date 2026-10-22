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

*Based on the exported PostgreSQL summaries for 15 individual stocks plus the SPY benchmark across the approximately 15-year study period. Cumulative returns below are **total price changes over the full period**, **not annualized returns**.*

### 1. The largest long-term gains came with substantial downside risk

**NVDA** had the highest cumulative price return (**67,907.66%**), followed by **TSLA** (**20,075.72%**), compared with **726.81%** for **SPY**. However, both stocks were substantially more volatile and experienced much deeper peak-to-trough declines than the benchmark:

| Security | Cumulative price return | Annualized volatility | Maximum drawdown |
| --- | ---: | ---: | ---: |
| NVDA | 67,907.66% | 44.64% | -66.34% |
| TSLA | 20,075.72% | 56.94% | -73.63% |
| SPY | 726.81% | 16.68% | -33.72% |
| JNJ | 446.99% | 17.34% | -27.38% |

The comparison illustrates why cumulative returns should be assessed alongside volatility and drawdown, rather than treated as a complete measure of investment performance.

### 2. Volatility and maximum drawdown are related but not interchangeable

Across the **15 individual stocks**, annualized volatility and the **magnitude of maximum drawdown** had a **Pearson correlation of 0.82**. This is a strong positive relationship within the selected sample, but the two measures capture different aspects of risk. For example, **JNJ** had a smaller maximum drawdown (**-27.38%**) than SPY (**-33.72%**), despite its lower cumulative price return. The correlation is descriptive, based on only 15 retrospectively selected securities, and should not be generalized to the broader market.

### 3. High-VIX trading days were associated with weaker SPY returns and greater daily volatility

During **low-VIX** observations, SPY's average daily return was **0.19%**, with **0.42%** daily return volatility. During **high-VIX** observations, its average daily return was **-0.14%**, while daily volatility rose to **1.73%** (about **4.1×** the low-VIX level).

All **15 individual stocks** also had negative *average daily returns* during the high-VIX regime. This is a historical, same-day association, **not evidence that VIX levels predict subsequent returns**.

### 4. Benchmark-relative leaders changed across volatility regimes

**NVDA** and **TSLA** led the basket on average daily excess return relative to SPY during low-VIX conditions (**+0.25 pp** and **+0.24 pp**, respectively). Their corresponding high-VIX excess returns were **-0.02 pp** and **-0.09 pp**.

By contrast, the strongest high-VIX average excess returns were **NEE (+0.12 pp)**, **XOM (+0.12 pp)**, and **WMT (+0.12 pp)**. XOM showed a particularly large shift, from **-0.12 pp** in low-VIX periods to **+0.12 pp** in high-VIX periods.

### 5. Relative resilience did not mean positive absolute returns

**Nine of the 15 stocks** had positive *average daily excess returns* versus SPY in the high-VIX regime; the other six had negative excess returns. Importantly, **all 15 stocks had negative average daily returns in that regime**. Outperformance here means losing less than SPY on average, not necessarily generating positive returns.

**Interpretation:** These results describe the selected stocks' historical behavior over the study period. VIX regimes were assigned retrospectively using the full sample's 25th and 75th percentile thresholds. Price adjustments, missing trading observations, selection bias, and the distinction between price and total returns limit broader investment conclusions.

**Underlying results:** [Performance and risk summary](results/stock_performance_summary.csv) · [VIX regime summary](results/stock_vix_regime_summary.csv) · [Interactive Tableau dashboard](https://public.tableau.com/app/profile/keane.tan7245/viz/EquityPerformanceMarketRiskAnalysis/Dashboard1)

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
