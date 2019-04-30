require 'open-uri'
require 'nokogiri'
require 'pry'

# This is a class method takes in an argument of a student's profile URL
class Scraper

  # this method is responsible for scraping the index page that lists all of the students
  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = []

    page.css("div.student-card").each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      profile_url = student.css("a").attribute("href").value

      student_info = {:name => name,
                      :location => location,
                      :profile_url => profile_url
                    }

      students.push(student_info)
      end
      students
  end

  # This method is responsible for scraping an individual student's profile page
  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    student = {}

    social_link = page.css(".social-icon-container a").collect do |icon|
      icon.attribute("href").value
    end

    social_link.each do |s_link|
      if s_link.include?("twitter")
        student[:twitter] = s_link
      elsif s_link.include?("linkedin")
        student[:linkedin] = s_link
      elsif s_link.include?("github")
        student[:github] = s_link
      elsif s_link.include?(".com")
        student[:blog] = s_link
      end
    end
      student[:profile_quote] = page.css(".profile-quote").text
      student[:bio] = page.css("div.description-holder p").text
      student
    end
end
