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
 
  def self.create_from_ncdpi_website
    (0...NcCharterSchools::Scraper.scrape_name.size).to_a.each do |sch|
      school = NcCharterSchools::School.new
      school.name = NcCharterSchools::Scraper.scrape_name[sch]
      school.url = NcCharterSchools::Scraper.scrape_url[sch]
      school.charter_code = NcCharterSchools::Scraper.scrape_charter_code[sch]
      school.city_state = NcCharterSchools::Scraper.scrape_city_state[sch]
      school.county = NcCharterSchools::Scraper.scrape_county[sch]
      school.telephone = NcCharterSchools::Scraper.scrape_telephone[sch]
      school.effective_date = NcCharterSchools::Scraper.scrape_effective_date[sch]
      school.grade = NcCharterSchools::Scraper.scrape_grade[sch]
    end
  end
 
  def self.view_schools
    sorted_schools.each.with_index(1) do |school, index|
      puts "#{index.to_s.concat('.').ljust(4)} #{school.name}  \n"
    end
    NcCharterSchools::CLI.menu
  end
 
  def self.find_school_by_name
    school = sorted_schools[@@user_input -1]
   
    puts "\nSchool Details\n" "-----------------"
    puts "Name:               #{school.name}"
    puts "Wesite:             #{school.url}"
    puts "Charter Code:       #{school.charter_code}"
    puts "City & State:       #{school.city_state}"
    puts "County:             #{school.county}"
    puts "Telephone:          #{school.telephone}"
    puts "Effective_date:     #{school.effective_date}"
    puts "Grade:              #{school.grade}"
    @@school_url = school.url  # variable used in open_school_website method to open website

    get_user_choice_on_school_website_visit
  end

  def self.sorted_schools
    sorted_schools ||= NcCharterSchools::School.all.sort_by { |school| school.name }
  end

  def self.get_user_choice_on_school_website_visit
    visit_school_website = TTY::Prompt.new.select("\nWould you like to visit the school's website? ", %w(No Yes)) 
    
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
    
    puts "\n\nPlease select county using assigned number"
    user_input = gets.chomp.to_i
    
    if until user_input > 0 && user_input <= get_school_counties.uniq.size do
      puts "\nYou made an invalid selection. Please try again"
      user_input = gets.chomp.to_i
      end
    else
      selected_county = get_school_counties.sort.uniq[user_input -1]
      puts "\n#{selected_county}\n"
      get_schools_by_county[selected_county].each.with_index(1) {|element, index| puts " #{index}. #{element}\n"}
    end
    NcCharterSchools::CLI.menu
  end
  
  def self.view_county_coverage_of_schools
    puts "\nNum  County          Schools\n"  "----------------------------"
    sorted_get_number_of_schools_by_county = get_number_of_schools_by_county.sort_by {|k, v| v}.reverse.to_h
      sorted_get_number_of_schools_by_county.each.with_index(1) do |(k, v), i|
        puts "#{i.to_s.concat('.').ljust(4)} #{k.ljust(get_number_of_schools_by_county.keys.max_by(&:length).length+8)} #{v.to_s.rjust(2)}"
      end
    puts "----------------------------\n"
    puts "Total Charter Schools    #{NcCharterSchools::School.all.size}\n\n"
    puts "NC county coverage     #{((get_number_of_schools_by_county.size.to_f/get_nc_counties.size)*100).round(1)}%\n"
    puts "----------------------------\n\n"

    NcCharterSchools::CLI.menu
  end

  def self.view_counties_without_charter_school
    counties_without_chartered_school = get_nc_counties - get_school_counties

    puts "\nNC counties without charter schools\n" "-----------------------------------"
    counties_without_chartered_school.each.with_index(1) {|county, index| puts "#{index.to_s.concat('.').ljust(4)} #{county}"}
    NcCharterSchools::CLI.menu
  end
  
  def self.view_schools_by_age_category
    age_category = TTY::Prompt.new.select("\nPlease select the time period of school effective date: ", %w(Under_1_year Between_1_and_5_years Between_5_and_10_years Over_10_years Menu))

    case age_category
      when "Under_1_year"
        get_schools_by_age_category(age_category, period="under 1")
      when "Between_1_and_5_years"
        get_schools_by_age_category(age_category, period="between 1 and 5")
      when "Between_5_and_10_years"
        get_schools_by_age_category(age_category, period="between 5 and 10")
      when "Over_10_years"
        get_schools_by_age_category(age_category, period="over 10")
      else
        NcCharterSchools::CLI.menu
    end
  end

  def self.get_schools_by_age_category(age_category, period)
    count = 0
    heading_for_view_schools_by_age_category

    merge_eff_date_and_school_name_sorted.each do |element|
      if period == "under 1" && element[0] > Time.now - calculate_year
        render_eff_date_and_school_name(element)
        count += 1
      elsif period == "between 1 and 5" && element[0] <= Time.now - calculate_year && element[0] > Time.now - (calculate_year * 5)
        render_eff_date_and_school_name(element)
        count += 1
      elsif period == "between 5 and 10" && element[0] <= Time.now - (calculate_year * 5) && element[0] > Time.now - (calculate_year * 10)
        render_eff_date_and_school_name(element)
        count += 1
      elsif period == "over 10" && element[0] <= Time.now - (calculate_year * 10)
        render_eff_date_and_school_name(element)
        count += 1
      end
    end
    puts "\n  #{count} school#{'s' if count > 1} with effective date #{age_category.downcase.gsub("_", " ")}"
    view_schools_by_age_category
  end

  def self.render_eff_date_and_school_name(element)
    puts "#{element[0].strftime("%m/%d/%Y")}        #{element[1]}"
  end

  def self.view_school_types
    sorted_school_type_hash = count_school_types.sort_by {|k, v| v}.reverse.to_h
    puts
    sorted_school_type_hash.each do |k, v|
        puts x = "#{k.ljust(30)} #{v.to_s.rjust(3)}     #{((v/NcCharterSchools::School.all.size.to_f)*100).round(1).to_s.concat('%').rjust(5)}"
    end
    puts "--------------------------------------------\n" "                    TOTAL      #{NcCharterSchools::School.all.size}\n"
    NcCharterSchools::CLI.menu
  end

  def self.heading_for_view_schools_by_age_category
    puts "\nEffective Date    School Name\n" "-----------------------------"
  end

  def self.count_school_types
    school_type_hash = Hash.new(0)
    get_school_type.each do |type|
        school_type_hash[type] += 1 
    end
    school_type_hash
  end

  def self.get_school_type
    NcCharterSchools::School.all.map do |element|
      if element.grade.start_with?(":P3", ":PK", ":KG") && element.grade.end_with?(":P3", ":PK", ":KG", ":01", ":02", ":03", ":04", ":05")
        "Elem School only"
      elsif element.grade.start_with?(":06") && element.grade.end_with?(":06", ":07", ":08")
        "Middle School only"
      elsif element.grade.start_with?(":09") && element.grade.end_with?(":09", ":10", ":11", ":12")
        "High School only"
      elsif element.grade.start_with?(":P3", ":PK", ":KG", ":01", ":02", ":03", ":04", ":05") && element.grade.end_with?( ":06", ":07", ":08")
        "Elem & Middle School"
      elsif element.grade.start_with?(":06", ":07", ":08") && element.grade.end_with?(":09", ":10", ":11", ":12")
        "Middle & High School"
      else
        "Elem, Middle & High School"
      end
    end
  end
  
  def self.merge_eff_date_and_school_name_sorted
    merge_eff_date_and_school_name.sort_by {|k, v| k}
  end

  def self.merge_eff_date_and_school_name
    NcCharterSchools::School.all.map {|i| [Time.strptime(i.effective_date, "%m-%d-%Y"), i.name]}
  end

  def self.calculate_year
    year = (60 * 60 * 24) * 365
  end

  def self.get_nc_counties
    NcCharterSchools::Scraper.scrape_nc_county
  end
  
  def self.get_number_of_schools_by_county
    county_hash = Hash.new{0}
    get_school_counties.each do |c|
      county_hash[c] += 1
    end
    county_hash
  end

  def self.get_school_counties
    NcCharterSchools::School.all.map {|c| c.county}
  end
  
  def self.get_user_input
    user_confirmation = TTY::Prompt.new.select("\nDo you have the assigned number of school you would like to find? ", %w(Yes No))
    
    if user_confirmation == "Yes"
      puts "\nPlease select between 1 and #{NcCharterSchools::School.all.size}"
      @@user_input = gets.chomp.to_i

      validate_user_input
    else
      puts "\nPlease select assigned number of school from alphabetical list that loads momentarily\n\n"

      15.times do
        print "."
        sleep 0.2
      end

      puts "\n\n\n"
      view_schools
    end
  end

  def self.validate_user_input
    if until @@user_input > 0 && @@user_input <= NcCharterSchools::School.all.size do 
      puts "\nYou made an invalid selection. Please try again"
      @@user_input = gets.chomp.to_i
      end          
    else
      @@user_input
      NcCharterSchools::School.find_school_by_name
    end
  end
  
  def self.get_schools_by_county
    county_sch_hash = Hash.new {|hash, key| hash[key] = []}

    merge_sch_county_and_school_name.each do |index|  
      county_sch_hash[index[0]] << index[1]
    end
    county_sch_hash
  end
  
  def self.merge_sch_county_and_school_name
    NcCharterSchools::School.all.map {|i| [i.county, i.name]}
  end
end