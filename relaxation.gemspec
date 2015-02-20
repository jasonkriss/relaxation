$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "relaxation/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "relaxation"
  s.version     = Relaxation::VERSION
  s.authors     = ["Jason Kriss"]
  s.email       = ["jasonkriss@gmail.com"]
  s.homepage    = "https://github.com/jasonkriss/relaxation"
  s.summary     = "Restful API controllers with less code."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
