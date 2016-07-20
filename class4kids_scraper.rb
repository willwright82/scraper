# nokogiri requires open-uri
require 'nokogiri'
require 'open-uri'
# csv will be used to export data
require 'csv'
require 'mechanize'
# pp is useful to display mechanize objects
require 'pp'


agent = Mechanize.new

# creates a Mechanize page
url = 'https://www.class4kids.co.uk/search#search/EH1?radius=50'

page = agent.get(url)

# opens a new csv file and shovels column titles into the first row
CSV.open("class4kids.csv", "w+") do |csv|
  csv << ["Name", "Provider", "Price"]
end

# intializes another_page and page_num variables
another_page = true
page_num = 1

# the while loop runs as long as the statement evaluates to true
while another_page == true
  # searches the page for each movie link
  page.search('div.search-results li a').each do |class_link|
    puts class_link.to_s
    class_url = class_link.attr('href')
    class_page = agent.get("#{class_url}")
    classes = class_page.search('div.inner-wrap')
    classes_array = []
    classes.each do |activity|
      provider = activity.css('div.class-detail-club-heading a.show-as-link')
      provider = provider.text.strip
      info = [class_link.text, provider]

      price = activity.css('div.class-detail-info-panel li.class-detail-info-item:nth-child(4)')
      if price.empty?
        info << "Free"
      else
        info << price.text.strip
      end
      classes_array << info
    end

    # appends info information onto the csv we already created
    CSV.open("class4kids.csv", "a+") do |csv|
      classes_array.each do |info|
        csv << info
      end
    end

    # output to terminal
    puts "#{class_link.text} saved"
    puts # extra line for spacing

  end

  # checks if there is a disabled right button class somewhere on the page
  disabled_right_button = page.search('div.content_body a.right.disabled')
  if disabled_right_button.any?
    another_page = false # stops the loop from running again
  else
    another_page = false # stops the loop from running again
    #page = agent.get("http://www.rottentomatoes.com/movie/in-theaters/?page=#{page_num+1}")
  end

  page_num += 1
end
