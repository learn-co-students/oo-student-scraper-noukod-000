class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url

  @@all = []

  def initialize(student)
    self.send("name=", student[:name])
    self.send("location=", student[:location])
    self.send("profile_url=", student[:profile_url])
    @@all << self
  end

  def self.create_from_collection(stu_arr)
    stu_arr.each {|st_hash| Student.new(st_hash)}
  end

  def add_student_attributes(attributes_hash)
    attributes_hash.each do |attribute, value|
      send("#{attribute}=", value)
    end
    self
  end

  def self.all
    @@all
  end
  # binding.pry?
end