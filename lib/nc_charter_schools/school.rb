class NcCharterSchools::School
  attr_accessor :name, :url, :charter_code, :city_state, :county, :telephone, :effective_date, :grade
  @@all = []
  
  def initialize
    save
  end
  
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
    end
   
 end
 
 def self.view_schools
    NcCharterSchools::School.all.each.with_index(1) do |sch, index|
      puts "#{index}. #{sch.name}  "
    end
    NcCharterSchools::CLI.menu
 end
 
 def self.find_school_by_number
   prompt = TTY::Prompt.new
   #user_input = gets.chomp.to_i
   user_input = @@user_input   # variable obtained from get_user_input method
   
   NcCharterSchools::School.all.find.with_index do |sch, index|
     if index == user_input -1
        puts
        puts "School Details"
        puts "-----------------"
        puts "Name:               #{sch.name}"
        puts "Wesite:             #{sch.url}"
        puts "Charter Code:       #{sch.charter_code}"
        puts "City & Code:        #{sch.city_state}"
        puts "County:             #{sch.county}"
        puts "Telephone:          #{sch.telephone}"
        puts "Effective_date:     #{sch.effective_date}"
        puts "Grade:              #{sch.grade}"
        @@school_url = index  # variable used in open_school_website method to open website
      end
    end
    puts
    
    visit_school_website = prompt.select("Would you like to visit the school's website? ", %w(Yes No)) 
    
    if visit_school_website == "Yes"
      open_school_website
      NcCharterSchools::CLI.menu
    else
      NcCharterSchools::CLI.menu
    end
  end

  def self.open_school_website
    urls = get_school_urls
    #user_input = gets.chomp.to_i
    user_input = @@school_url
    
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
    NcCharterSchools::CLI.menu
  end
  
  def self.get_user_input #
    prompt = TTY::Prompt.new
    puts
    user_confirmation = prompt.select("Do you have the assigned number of school you would like to find? ", %w(Yes No))
    
    if user_confirmation == "Yes"
      puts
      puts "Please select between 1 and #{ NcCharterSchools::School.all.size}"
      user_input = gets.chomp.to_i

      if until user_input > 0 && user_input <= NcCharterSchools::School.all.size do 
        puts 
        puts "You made an invalid selection. Please try again"
        user_input = gets.chomp.to_i
        end          
      else
        @@user_input = user_input
        NcCharterSchools::School.find_school_by_number
      end
    else
      puts
      puts "Please select from alphabetical list of schools which will be available momentarily"
      sleep 2.5
      view_schools
      puts
    end
  end
  
  def self.get_school_name  #
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

