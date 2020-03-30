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
 
  def self.find_school_by_name
    prompt = TTY::Prompt.new
    user_input = @@user_input   # variable obtained from get_user_input method
    school = NcCharterSchools::School.all[user_input -1]
   
        puts "\nSchool Details"
        puts "-----------------"
        puts "Name:               #{school.name}"
        puts "Wesite:             #{school.url}"
        puts "Charter Code:       #{school.charter_code}"
        puts "City & State:       #{school.city_state}"
        puts "County:             #{school.county}"
        puts "Telephone:          #{school.telephone}"
        puts "Effective_date:     #{school.effective_date}"
        puts "Grade:              #{school.grade}"
        @@school_url = school.url  # variable used in open_school_website method to open website
    
    visit_school_website = prompt.select("\nWould you like to visit the school's website? ", %w(No Yes)) 
    
    if visit_school_website == "Yes"
      open_school_website
      NcCharterSchools::CLI.menu
    else
      NcCharterSchools::CLI.menu
    end
  end

  def self.open_school_website
    if @@school_url.include?("http") || @@school_url.include?("www")
      system("open '#{@@school_url}'")
    else
      puts "\nThere is no valid website available for this school\n\n"
    end
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
      puts "You made an invalid selection. Please try again"
      user_input = gets.chomp.to_i
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
  
  def self.view_county_coverage_of_schools
    puts
    puts "County           Schools"
    puts "------------------------"
    sorted_get_number_of_schools_by_county = get_number_of_schools_by_county.sort_by {|k, v| v}.reverse.to_h
      sorted_get_number_of_schools_by_county.each do |k, v|
        puts "#{k.ljust(get_number_of_schools_by_county.keys.max_by(&:length).length)}          #{v}"
      end
    puts "-----------------------"
    puts "No. of counties      #{get_number_of_schools_by_county.size}"
    puts
    puts "NC county coverage #{((get_number_of_schools_by_county.size.to_f/get_nc_counties.size)*100).round(1)}%"
    puts
    NcCharterSchools::CLI.menu
  end

  def self.view_counties_without_charter_school
    counties_without = get_nc_counties - get_school_counties
    puts
    puts "NC counties without charter schools"
    puts "-----------------------------------"
    
    counties_without.each.with_index(1) {|county, index| puts "#{index}. #{county}"}
    NcCharterSchools::CLI.menu
  end
  
  def self.view_schools_by_age_category
    prompt = TTY::Prompt.new
    calculate_year
    count = 0
    
    puts
    age_category = prompt.select("Please select the time period of school effective date: ", %w(Under_1_year Between_1_and_5_years Between_5_and_10_years Over_10_years Menu))

    case age_category
      when "Under_1_year"
        heading_for_view_schools_by_age_category
        merge_eff_date_and_school_name.select do |element|
          if element[0] > Time.now - calculate_year
            puts "#{element[0].strftime("%m/%d/%Y")}        #{element[1]}"
            count += 1
          end
        end
      puts
      puts "  #{count} school(s) with effective date #{age_category.downcase.gsub("_", " ")}"
      view_schools_by_age_category
      when "Between_1_and_5_years"
        heading_for_view_schools_by_age_category
        merge_eff_date_and_school_name.select do |element|
          if element[0] <= Time.now - calculate_year && element[0] > Time.now - (calculate_year * 5)
            puts "#{element[0].strftime("%m/%d/%Y")}        #{element[1]}"
             count += 1
          end
        end
        puts
        puts "  #{count} school(s) with effective date #{age_category.downcase.gsub("_", " ")}"
        view_schools_by_age_category
      when "Between_5_and_10_years"
        heading_for_view_schools_by_age_category
        merge_eff_date_and_school_name.select do |element|
          if element[0] <= Time.now - (calculate_year * 5) && element[0] > Time.now - (calculate_year * 10)
            puts "#{element[0].strftime("%m/%d/%Y")}        #{element[1]}"
            count += 1
          end
        end
        puts
        puts "  #{count} school(s) with effective date #{age_category.downcase.gsub("_", " ")}"
        view_schools_by_age_category
      when "Over_10_years"
        heading_for_view_schools_by_age_category
        merge_eff_date_and_school_name.select do |element|
          if element[0] <= Time.now - (calculate_year * 10) 
            puts "#{element[0].strftime("%m/%d/%Y")}        #{element[1]}"
            count += 1
          end
        end
        puts
        puts "  #{count} school(s) with effective date #{age_category.downcase.gsub("_", " ")}"
        view_schools_by_age_category
      else
        NcCharterSchools::CLI.menu
        puts
    end
  end

  def self.view_school_types
    sorted_school_type_hash = count_school_types.sort_by {|k, v| v}.reverse.to_h
    puts
    sorted_school_type_hash.each do |k, v|
        puts "#{k.ljust(30)} #{v}   (#{((v/NcCharterSchools::School.all.size.to_f)*100).round(1)}%)"
    end
    puts "---------------------------------------"
    puts "                    TOTAL      #{NcCharterSchools::School.all.size}"
    puts
    NcCharterSchools::CLI.menu
  end

  def self.heading_for_view_schools_by_age_category #
    puts
    puts "Effective Date    School Name"
    puts "-----------------------------"
  end

  def self.count_school_types #
    school_type_hash = Hash.new(0)
    get_school_type.each do |type|
        school_type_hash[type] += 1 
    end
    school_type_hash
  end

  def self.get_school_type
    NcCharterSchools::School.all.map do |element|
      if element.grade == ":KG:01:02:03:04:05" || element.grade == ":KG"
        "Elem School only"
      elsif element.grade == ":06:07:08"
        "Middle School only"
      elsif element.grade == ":09:10:11:12"
        "High School only"
      elsif element.grade == ":01:02:03:04:05:06:07:08" || element.grade == "03:04:05:06:07:08" || element.grade == "KG:01:02:03:04:05:06" || element.grade == ":KG:01:02:03:04:05:06:07:08" || element.grade == ":05:06:07:08" || element.grade == ":P3:PK:KG:01:02:03:04:05:06:07:08" || element.grade == ":PK:KG:01:02:03:04:05:06:07:08"
        "Elem & Middle School"
      elsif element.grade == "06:07:08:09:10:11" || element.grade == ":06:07:08:09:10:11:12"
        "Middle & High School"
      else
        "Elem, Middle & High School"
      end
    end
  end

  def self.merge_eff_date_and_school_name #
    get_effective_date.zip(get_school_name)
  end

  def self.get_effective_date #
    date = NcCharterSchools::School.all.map {|date| date.effective_date}.map {|t| Time.strptime(t, "%m-%d-%Y")}
  end

  def self.calculate_year #
    day = 60 * 60 * 24
    year = 365 * day
  end

  def self.get_nc_counties  #
    NcCharterSchools::Scraper.scrape_nc_county
  end
  
  def self.get_number_of_schools_by_county  #
    county_hash = Hash.new{0}
    get_school_counties.each do |c|
      county_hash[c] += 1
    end
    county_hash
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
        NcCharterSchools::School.find_school_by_name
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

