# Amazon Product Scraper (Educational Purpose)

This is a simple Ruby script that demonstrates how to scrape product information from Amazon's search results and individual product pages using `Nokogiri` and `Net::HTTP`.

The script collects the following information for each product:
- Title
- Price
- Rating
- Number of reviews
- Availability

The collected data is saved to a CSV file.

## How it works

1. Sends an HTTP GET request to the provided Amazon search URL.
2. Extracts product links from the search results page.
3. Visits each product page and scrapes details.
4. Saves the data into a file named `amazon_data.csv`.

## Requirements

Ruby must be installed on your system. Additionally, you need to install the `nokogiri` gem:

```bash
gem install nokogiri
```

## Usage

To run the script:

```bash
ruby amazon_scraper.rb
```

The output will be saved to `amazon_data.csv` in the current directory.

## Important Note

This project is created strictly for educational purposes.

- Do not use it for commercial or automated large-scale data extraction.
- Amazon's Terms of Service prohibit web scraping. Use of this script may violate those terms.
- The script may break at any time due to changes in Amazon's website structure.
- For legal and reliable access to Amazon product data, consider using the official [Product Advertising API](https://affiliate-program.amazon.com/).
