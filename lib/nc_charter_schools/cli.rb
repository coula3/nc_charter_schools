class NcCharterSchools::CLI
  def call
    puts
    puts
    puts " ================================================================== "
    puts "|     Welcome to CLI App on Charter Schools in North Carolina!     |"
    puts " ================================================================== "
    puts
    puts
    
    NcCharterSchools::School.new_from_ncdpi_website
    
    self.class.menu
  end

  def self.menu
    puts
    prompt = TTY::Prompt.new
    menu = prompt.select("Please select what you would like to do:  ", %w(View_Schools  Find_School_by_Number Find_Schools_by_County View_County_Coverage_of_Schools View_Counties_without_Charter_School View_Schools_by_Age_Category Exit))
  
    case menu
      when "View_Schools"
        NcCharterSchools::School.view_schools
      when "Find_School_by_Number"
        NcCharterSchools::School.get_user_input
      when "Find_Schools_by_County"
        NcCharterSchools::School.find_schools_by_county
      when "View_County_Coverage_of_Schools"
        NcCharterSchools::School.view_county_coverage_of_schools
      when "View_Counties_without_Charter_School"
        NcCharterSchools::School.view_counties_without_charter_school
      when "View_Schools_by_Age_Category"
        NcCharterSchools::School.view_schools_by_age_category
      else
        puts
        puts "Thank you for using the app and goodbye!"
        puts
        sleep 1.0
        exit
    end
  end
end