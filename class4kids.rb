require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'csv'

include Capybara::DSL
Capybara.default_driver = :poltergeist

headers = ['Title','URL','Runs','Category','Age','Venue','Price','Image', 'Description']
CSV.open('class4kids.csv', 'w+') do |csv|
  csv << headers
end

page.driver.browser.js_errors = false
visit "https://www.class4kids.co.uk/search#search/EH1?radius=20"
sleep 12

results = page.find("#totalResults span").text.to_i
puts results.to_s+' Results found'
scroll = (results/12)-1
counter = 1
scroll = 1
scroll.times do
  counter = counter + 1
  #page.driver.scroll_to 0, 999000
  #page.execute_script "window.scrollBy(0,999000)"
  #page.evaluate_script "window.scrollBy(0,999000)"
  sleep 2
  #page.save_screenshot
end

1.times do
  activities = []

  all("#results-region li a.class-item").each do |listing|
    title = listing.find("h3.mbs").text
    url = listing["href"]
    runs = listing.find(".class-schedule h4.class-item-runs").text
    category = listing.find("h5.pre-heading.mbs").text
    age = listing.find(".list-class-details dd:nth-child(2)").text
    venue = listing.find(".list-class-details dd:nth-child(3)").text
    price = listing.find(".list-class-details dd:nth-child(5)").text
    image = listing.find(".media-object img")["src"]
    image = image.to_s.gsub! 'https://app.resrc.it/S=W128/', ''

    activities << {
      title: title,
      url: url,
      runs: runs,
      category: category,
      age: age,
      venue: venue,
      price: price,
      image: image
    }

  end

  activities.each do |activity|
    visit activity[:url]
    sleep 2
    if page.has_css?("p.class-detail-info span.full-description.hidden")
      activity[:description] = find("p.class-detail-info span.full-description.hidden").text
    else
      activity[:description] = find("p.class-detail-info").text
    end

    puts activity[:title]
    puts activity[:url]
    puts activity[:runs]
    puts activity[:category]
    puts activity[:age]
    puts activity[:venue]
    puts activity[:price]
    puts activity[:image]
    puts activity[:description]
    puts ''

    CSV.open('class4kids.csv', 'a+') do |csv|
      csv << [
        activity[:title],
        activity[:url],
        activity[:runs],
        activity[:category],
        activity[:age],
        activity[:venue],
        activity[:price],
        activity[:image],
        activity[:description]
      ]
    end
  end

end
