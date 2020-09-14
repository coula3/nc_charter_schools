class NcCharterSchools::CLI
  def call
    
    puts "\n\n ================================================================== "
    puts "|     Welcome to CLI App on Charter Schools in North Carolina!     |"
    puts " ================================================================== \n\n\n"
    
    NcCharterSchools::School.create_from_ncdpi_website

    self.class.menu
  end

  def self.menu
    menu = TTY::Prompt.new.select("\nPlease select what you would like to do:  ", %w(View_Schools  Find_School_by_Name Find_Schools_by_County View_County_Coverage_of_Schools View_Counties_without_Charter_School View_Schools_by_Age_Category View_School_Types Exit))
  
    case menu
      when "View_Schools"
        NcCharterSchools::School.view_schools
      when "Find_School_by_Name"
        NcCharterSchools::School.get_user_input
      when "Find_Schools_by_County"
        NcCharterSchools::School.find_schools_by_county
      when "View_County_Coverage_of_Schools"
        NcCharterSchools::School.view_county_coverage_of_schools
      when "View_Counties_without_Charter_School"
        NcCharterSchools::School.view_counties_without_charter_school
      when "View_Schools_by_Age_Category"
        NcCharterSchools::School.view_schools_by_age_category
      when "View_School_Types"
        NcCharterSchools::School.view_school_types
      else
        puts "\nThank you for using the app and goodbye!\n\n\n"
        sleep 1.0
        exit
    end
  end
end