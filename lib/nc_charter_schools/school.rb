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
      (0..NcCharterSchools::Scraper.scrape_name.size).to_a.each do |sch|
        name = NcCharterSchools::Scraper.scrape_name[sch]
        url = NcCharterSchools::Scraper.scrape_url[sch]
        charter_code = NcCharterSchools::Scraper.scrape_charter_code[sch]
        county = NcCharterSchools::Scraper.scrape_county[sch]
        telephone = NcCharterSchools::Scraper.scrape_telephone[sch]
        effective_date = NcCharterSchools::Scraper.scrape_effective_date[sch]
        grade = NcCharterSchools::Scraper.scrape_grade[sch]
        
        school = NcCharterSchools::School.new
        binding.pry
      end
      
    end
end