class NcCharterSchools::School
  attr_accessor :name, :url, :charter_code, :city_state, :county, :telephone, :effective_date, :grade
  @@all = []
  
  def self.all
    @@all
  end
  
  def save
    @@all << self
  end
 
 def self.new_from_ncdpi_website
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
      print "#{index}. #{sch.name}  "
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
  
  def self.get_school_urls  #
    NcCharterSchools::School.all.map {|sch| sch.url}
  end
  
  def self.find_schools_by_county
    puts
    get_school_counties.sort.uniq.each.with_index(1) do |county, index|
      print "#{index}. #{county}  "
    end
    
    puts
    puts "Please select county using assigned number"
    
    user_input = gets.chomp.to_i
    
    if until user_input > 0 && user_input <= get_school_counties.uniq.size do
      puts
      puts ""
      user_input = gets.chomp.to.i
      end
    else
      puts
      selected_county = get_school_counties.sort.uniq[user_input -1]
      get_schools_by_county.find do |k, v|
        if k == selected_county
          puts "#{k}"
          puts
          v.each.with_index(1) {|element, index| puts " #{index}. #{element}"}
        end
      end
    end
  end
  
  def self.get_school_name
    name = NcCharterSchools::School.all.map {|n| n.name}
  end
  
  def self.get_schools_by_county  #
    county_sch_hash = Hash.new {|hash, key| hash[key] = []}

    merge_sch_county_and_school_name.each do |index|  
      county_sch_hash[index[0]] << index[1]
    end
    county_sch_hash
  end
  
  def self.merge_sch_county_and_school_name   #
    get_school_counties.zip(get_school_name)
  end
  
  def self.get_school_counties  #
    NcCharterSchools::School.all.map {|c| c.county}
  end
end

