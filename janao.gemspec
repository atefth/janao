$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "janao/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "janao"
  s.version     = Janao::VERSION
  s.authors     = ["Atef Haque"]
  s.email       = ["atefth@gmail.com"]
  s.homepage    = ""
  s.summary     = "Notifications through multiple channels"
  s.description = "Send out emails/sms/push notifications with ease"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"
  s.add_dependency "byebug"
  s.add_dependency "fuubar"
  s.add_dependency "rspec-rails"

  s.add_development_dependency "sqlite3"
end
