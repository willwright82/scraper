require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'

# Request the page to scrape
#puts 'URL to scrape:'
#url = gets.chomp.to_s

#page = HTTParty.get(url)
page = HTTParty.get('https://www.class4kids.co.uk/sport/swimming/122346/free-baby-and-toddler-taster-day')

# Transform HTTP response into a nokogiri object
parse_page = Nokogiri::HTML(page)

headers = ['Title','Provider','Category','Description']
# Reset CSV file
CSV.open('classes.csv', 'w+') do |csv|
  csv << headers
end

# Array to store all classes
classes_array = []
1.times do
  # Array to store all class info
  class_array = []

  class_title = parse_page.at('title').text.tr("\n","").tr("\t","")
  class_provider = parse_page.css('.class-detail-club-heading').css('.show-as-link').text.tr("\n","").tr("\t","")
  class_category = parse_page.css('li.class-detail-info-item').first.text.tr("\n","").tr("\t","")
  class_description = parse_page.at('span[itemprop="description"]').text.tr("\n","").tr("\t","")

  class_array.push(class_title)
  class_array.push(class_provider)
  class_array.push(class_category)
  class_array.push(class_description)

  # Parse the title
  #parse_page.at('title').map do |a|
  #class_name = a.text
  #class_array.push(class_name)
  #end

  # Push array into a CSV file
  CSV.open('classes.csv', 'a+') do |csv|
    csv << class_array
  end
  classes_array << class_array
end

puts classes_array
Pry.start(binding)
