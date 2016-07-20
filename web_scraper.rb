require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'

# Request the page to scrape
#page = HTTParty.get('https://newyork.craigslist.org/search/pet?s=0')

#puts 'URL to scrape:'
#url = gets.chomp.to_s

#page = HTTParty.get(url)
page = HTTParty.get('https://www.class4kids.co.uk/sport/swimming/122346/free-baby-and-toddler-taster-day')

# Transform HTTP response into a nokogiri object
parse_page = Nokogiri::HTML(page)

headers = ['Title','Provider','Category','Description']

# Array to store all pets
class_array = []
# Class Title
class_array.push(parse_page.at('title').text.tr("\n","").tr("\t",""))
# Class Provider
class_array.push(parse_page.css('.class-detail-club-heading').css('.show-as-link').text.tr("\n","").tr("\t",""))
#Class Category
#"selector": "//li[@class='class-detail-info-item'][1]",
class_array.push(parse_page.css('li.class-detail-info-item').first.text.tr("\n","").tr("\t",""))
# Class Description
class_array.push(parse_page.at('span[itemprop="description"]').text.tr("\n","").tr("\t",""))

# Parse the title
#parse_page.at('title').map do |a|
  #class_name = a.text
  #class_array.push(class_name)
#end

# Push array into a CSV file
#CSV.open('classes.csv', 'w') do |csv|
  #csv << headers
  #csv << class_array
#end

Pry.start(binding)
#puts class_array
