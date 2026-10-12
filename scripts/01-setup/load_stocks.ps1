$env:PGPASSWORD = "XXXX"
$psql = "C:\Program Files\PostgreSQL\18\pgAdmin 4\runtime\psql.exe"

Get-ChildItem *.csv | ForEach-Object {
  $t = $_.BaseName.ToUpper()
  @"
TRUNCATE stg;
\copy stg FROM '$($_.Name)' WITH (FORMAT csv, HEADER true)
INSERT INTO stock_prices SELECT '$t', * FROM stg ON CONFLICT DO NOTHING;
"@ | & $psql -U postgres -d stock_market_project
}
