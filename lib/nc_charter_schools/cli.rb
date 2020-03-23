class NcCharterSchools::CLI
  def call
    puts "Welcome to NC Charter Schools CLI App!"
    NcCharterSchools::School.new_from_ncdpi_website
    NcCharterSchools::School.find_schools_by_county
  end
  
end