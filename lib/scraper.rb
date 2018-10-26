require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    students = []

    doc.css(".student-card").each do |student|
      students << {
        name: student.css(".student-name").text,
        location: student.css(".student-location").text,
        profile_url: student.css("a").attribute("href").value
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

    other_info = {}
    doc.css(".social-icon-container a").each do |social|
      social_network_url = social.attribute("href").value

      if social_network_url.include?("twitter")
        other_info[:twitter] = social_network_url
      elsif social_network_url.include?("linkedin")
        other_info[:linkedin] = social_network_url
      elsif social_network_url.include?("github")
        other_info[:github] = social_network_url
      else
        other_info[:blog] = social_network_url if social_network_url.include?("http://")
      end
    end

    other_info[:profile_quote] = doc.css(".profile-quote").text
    other_info[:bio] = doc.css(".description-holder p").text

    other_info
  end

end
