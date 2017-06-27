$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "load_more/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "load_more"
  s.version     = LoadMore::VERSION
  s.authors     = ["Niklas Granander"]
  s.email       = ["niklas.granander@ek-s.se"]
  s.homepage    = "https://github.com/niklasgranander/load_more"
  s.summary     = "Summary of LoadMore."
  s.description = "Description of LoadMore."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.5"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"

end
