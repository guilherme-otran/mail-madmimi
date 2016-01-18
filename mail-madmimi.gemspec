# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mail/madmimi/version'

Gem::Specification.new do |s|
  s.name        = "mail-madmimi"
  s.version     = Mail::Madmimi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Guilherme Otranto"]
  s.email       = ["guilherme_otran@hotmail.com"]
  s.summary     = "A Mad Mimi Mail delivery for ActionMailer, Rails 4."
  s.description = "ActionMailer send method for madmimi api"
  s.homepage    = "https://github.com/tagview/mail-madmimi"
  s.license     = "Ruby"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # This gem will work with 1.9.3 or greater
  s.required_ruby_version = ">= 1.9.3"
  s.add_runtime_dependency "httparty", "~> 0.13.2"
  s.add_runtime_dependency "mail", "~> 2.5", ">= 2.5.4"
  s.add_runtime_dependency "actionmailer", "~> 4.0", ">= 4.0.0"

  s.add_development_dependency "rspec", "~> 3.4"
  s.add_development_dependency "rubocop", "~> 0.36"
end
