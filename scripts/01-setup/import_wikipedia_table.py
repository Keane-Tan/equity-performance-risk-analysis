import pandas as pd
import requests

# 1. Define your URL
url = "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"

# 2. Add a standard User-Agent header so Wikipedia knows you aren't a malicious bot
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36"
}

# 3. Fetch the webpage content with your headers
response = requests.get(url, headers=headers)

# 4. Pass the text content into pandas to read the tables
tables = pd.read_html(response.text)

# 5. Extract the first table and save it to a CSV file
first_table = tables[0]
first_table.to_csv("sp500_stock_info.csv", index=False)

print("Table successfully exported to CSV!")
