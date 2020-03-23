class NcCharterSchools::CLI
  def call
    puts "Welcome to NC Charter Schools CLI App!"
    NcCharterSchools::School.new_from_ncdpi_website
    NcCharterSchools::School.open_school_website
  end
  
end