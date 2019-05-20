require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
      html = open(index_url)
      doc = Nokogiri::HTML(html)
      scrape_students = []

      doc.css("div.student-card").each do |student|
        name = student.css(".student-name").text
        location = student.css(".student-location").text
        profile_url = student.css("a").attribute("href").value

        hash = {:name => name,
                :location => location,
                :profile_url => profile_url
               }

        scrape_students << hash
      end
      scrape_students
  end

def self.scrape_profile_page(profile_url)

   doc = Nokogiri::HTML(open(profile_url))
   student = {}
   link = doc.css(".social-icon-container a").collect do |icon|
   icon.attribute("href").value
   end

   link.each do |social_link|
   if social_link.include?("twitter")
     student[:twitter] = social_link
   elsif social_link.include?("linkedin")
     student[:linkedin] = social_link
   elsif social_link.include?("github")
     student[:github] = social_link
   elsif social_link.include?(".com")
     student[:blog] = social_link
   end
  end
  student[:profile_quote] = doc.css(".profile-quote").text
  student[:bio] = doc.css("div.description-holder p").text
  student
  end

end
