class NcCharterSchools::CLI
  def call
    puts "Welcome to NC Charter Schools CLI App!"
    NcCharterSchools::School.get_school_data
    NcCharterSchools::School.view_schools
  end
  
end