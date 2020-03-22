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
   
 end
end