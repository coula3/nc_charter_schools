
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nc_charter_schools/version"

Gem::Specification.new do |spec|
  spec.name          = "nc_charter_schools"
  spec.version       = NcCharterSchools::VERSION
  spec.authors       = ["'Alvin Coulson'"]
  spec.email         = ["'aaacoulson@gmail.com'"]

  spec.summary       = %q{An analysis of charter schools in North Carolina}
  spec.description   = %q{The CLI app on NC charter schools provides analysis of the headline data maintained by the NC Department of Public Instruction (DPI). The users will include parents, charter management organizations, advocates of increased access to public charter schools and other public education stakeholders and interest groups. The app extends the functionality of data maintained by NC DPI website and other related websites by providing users with information of added value to decision making.}
  spec.homepage      = "http://www.nccharterschools.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://www.nccharterschools.com"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "http://www.nccharterschools.com"
    spec.metadata["changelog_uri"] = "http://www.nccharterschools.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_dependency "nokogiri"
  spec.add_dependency "tty-prompt"
  
end
