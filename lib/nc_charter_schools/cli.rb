class NcCharterSchools::CLI
  def call
    puts "Welcome to NC Charter Schools CLI App!"
    puts NcCharterSchools::School.get_school_data
  end
  
end