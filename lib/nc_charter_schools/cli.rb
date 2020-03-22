class NcCharterSchools::CLI
  def call
    puts "Welcome to NC Charter Schools CLI App!"
    NcCharterSchools::School.get_school_data
    NcCharterSchools::School.find_by_number
  end
  
end