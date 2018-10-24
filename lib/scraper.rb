
require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  attr_accessor :students
  def self.scrape_index_page(index_url)
    html = open(index_url)
       list = Nokogiri::HTML(html)

       names = list.css(".student-name")
       names_array = []
       names.each do |item|
         names_array << item.text
       end
       names_array
       locations = list.css(".student-location")
       location_array = []
       locations.each do |item|
         location_array << item.text
       end
       location_array
       webpages = list.css(".student-card a[href]")
       webpage_array = []
       webpages.select do |item|
         webpage_array << item['href']
       end
       webpage_array
       master_array = []
       x = 0
       names_array.each do |name|
         master_array << {:name => name, :location => location_array[x], :profile_url => webpage_array[x]}
         x += 1
       end
       master_array
     end
  def self.scrape_profile_page(profile_url)
    profile_html = open(profile_url)
        profile_doc = Nokogiri::HTML(profile_html)
        attributes = {}
        profile_doc.css("div.social-icon-container a").each do |link_xml|
          case link_xml.attribute("href").value
          when /twitter/
            attributes[:twitter] = link_xml.attribute("href").value
          when /github/
            attributes[:github] = link_xml.attribute("href").value
          when /linkedin/
            attributes[:linkedin] = link_xml.attribute("href").value
          else
              attributes[:blog] = link_xml.attribute("href").value
          end
        end
        attributes[:profile_quote] = profile_doc.css("div.profile-quote").text
        attributes[:bio] = profile_doc.css("div.bio-content div.description-holder").text.strip
        attributes
  end

end
