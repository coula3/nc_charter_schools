class NcCharterSchools::School
  attr_accessor :name, :url, :charter_code, :city_state, :county, :telephone, :effective_date, :grade
  @@all = []
  
  def self.all
    @@all
  end
  
  def save
    @@all << self
  end
 
 def self.get_school_data
    (0...NcCharterSchools::Scraper.scrape_name.size).to_a.each do |sch|
      name = NcCharterSchools::Scraper.scrape_name[sch]
      url = NcCharterSchools::Scraper.scrape_url[sch]
      charter_code = NcCharterSchools::Scraper.scrape_charter_code[sch]
      city_state = NcCharterSchools::Scraper.scrape_city_state[sch]
      county = NcCharterSchools::Scraper.scrape_county[sch]
      telephone = NcCharterSchools::Scraper.scrape_telephone[sch]
      effective_date = NcCharterSchools::Scraper.scrape_effective_date[sch]
      grade = NcCharterSchools::Scraper.scrape_grade[sch]
      
      school = NcCharterSchools::School.new
      school.name = name
      school.url = url
      school.charter_code = charter_code
      school.city_state = city_state
      school.county = county
      school.telephone = telephone
      school.effective_date = effective_date
      school.grade = grade
      school.save
    end
   
 end
 
 def self.view_schools
    NcCharterSchools::School.all.each.with_index(1) do |sch, index|
      puts "#{index}. #{sch.name}"
    end
 end
 
 def self.find_by_number
   user_input = gets.chomp.to_i
   
   NcCharterSchools::School.all.find.with_index do |sch, index|
     if index == user_input -1
        puts
        puts "Details of Schools"
        puts "Name:               #{sch.name}"
        puts "URL:                #{sch.url}"
        puts "Charter Code:       #{sch.charter_code}"
        puts "City & Code:        #{sch.city_state}"
        puts "County:             #{sch.county}"
        puts "Telephone:          #{sch.telephone}"
        puts "Effective_date:     #{sch.effective_date}"
        puts "Grade:              #{sch.grade}"
      end
    end 
  end

  def self.open_school_website
    urls = get_school_urls
    user_input = gets.chomp.to_i
    
    if urls[user_input].include?("http") || urls[user_input].include?("www")
      system("open '#{urls[user_input]}'")
    else
      puts "There is no valid website available for this school"
    end
  end
  
  def self.get_school_urls
     NcCharterSchools::School.all.map {|sch| sch.url}
  end
end

