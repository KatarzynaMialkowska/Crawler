require 'nokogiri'
require 'net/http'
require 'uri'
require 'csv'

def get_title(soup)
  title = soup.at_css("span#productTitle")&.text&.strip || ""
  title
end

def get_price(soup)
  price = soup.at_css("span#priceblock_ourprice")&.text&.strip ||
          soup.at_css("span#priceblock_dealprice")&.text&.strip || ""
  price
end

def get_rating(soup)
  rating = soup.at_css("i.a-icon-star span")&.text&.strip || ""
  rating
end

def get_review_count(soup)
  review_count = soup.at_css("span#acrCustomerReviewText")&.text&.strip || ""
  review_count
end

def get_availability(soup)
  available = soup.at_css("div#availability span")&.text&.strip || "Not Available"
  available
end

def fetch_product_details(url, headers)
  uri = URI(url)
  req = Net::HTTP::Get.new(uri, headers)
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(req) }
  soup = Nokogiri::HTML(res.body)

  links = soup.css("a.a-link-normal.s-no-outline").map { |link| link['href'] }
  data = { title: [], price: [], rating: [], reviews: [], availability: [] }

  links.each do |link|
    product_uri = URI("https://www.amazon.com" + link)
    product_req = Net::HTTP::Get.new(product_uri, headers)
    product_res = Net::HTTP.start(product_uri.hostname, product_uri.port, use_ssl: product_uri.scheme == 'https') { |http| http.request(product_req) }
    product_soup = Nokogiri::HTML(product_res.body)

    data[:title] << get_title(product_soup)
    data[:price] << get_price(product_soup)
    data[:rating] << get_rating(product_soup)
    data[:reviews] << get_review_count(product_soup)
    data[:availability] << get_availability(product_soup)
  end

  data
end

def save_to_csv(data, filename)
  CSV.open(filename, "w", headers: data.keys, write_headers: true) do |csv|
    data[:title].each_with_index do |_, i|
      csv << data.keys.map { |key| data[key][i] }
    end
  end
end

URL = "https://www.amazon.com/s?k=playstation+5&crid=3BV45YDFQQE2G&sprefix=playstation+4%2Caps%2C269&ref=nb_sb_noss_2"
HEADERS = { 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36', 'Accept-Language' => 'en-US, en;q=0.5' }

puts "Fetching data from Amazon"
data = fetch_product_details(URL, HEADERS)
puts "Data fetched successfully"

save_to_csv(data, "amazon_data.csv")
puts "Data saved to amazon_data.csv"
