# require "nc_charter_schools/version"

require 'nokogiri'
require 'open-uri'

require_relative './nc_charter_schools/version'
require_relative './nc_charter_schools/cli'
require_relative './nc_charter_schools/school'
require_relative './nc_charter_schools/scraper'

module NcCharterSchools
  class Error < StandardError; end
  # Your code goes here...
end
