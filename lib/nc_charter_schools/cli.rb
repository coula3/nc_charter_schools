class NcCharterSchools::CLI
  def call
    puts "Welcome to NC Charter Schools CLI App!"
    NcCharterSchools::School.get_school_data
    NcCharterSchools::School.open_school_website
  end
  
end