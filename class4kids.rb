require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'csv'

include Capybara::DSL
Capybara.default_driver = :poltergeist

headers = ['Title','URL','Date','Summary']
CSV.open('class4kids.csv', 'w+') do |csv|
  csv << headers
end

visit "http://ngauthier.com/"

all(".posts .post").each do |post|
  title = post.find("h3 a").text
  url = post.find("h3 a")["href"]
  date = post.find("h3 small").text
  summary = post.find("p.preview").text

  puts title
  puts url
  puts date
  puts summary
  puts ""

  CSV.open('class4kids.csv', 'a+') do |csv|
    csv << [title, url, date, summary]
  end
end

