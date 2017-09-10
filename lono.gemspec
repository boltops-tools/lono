# -*- encoding: utf-8 -*-
require_relative "lib/lono/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Tung Nguyen"]
  gem.email         = ["tongueroo@gmail.com"]
  gem.description   = %q{Lono is a CloudFormation Template ruby generator.  Lono generates CloudFormation templates based on ERB templates.}
  gem.summary       = %q{Lono is a CloudFormation Template ruby generator.  Lono generates CloudFormation templates based on ERB templates.}
  gem.homepage      = "http://github.com/tongueroo/lono"

  files = `git ls-files`.split($\) + Dir.glob("vendor/**/*")
  files = files.reject { |p| p =~ /^docs/ }
  gem.files         = files
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features|docs)/})
  gem.name          = "lono"
  gem.require_paths = ["lib"]
  gem.version       = Lono::VERSION
  gem.license       = "MIT"

  gem.add_dependency "json"
  gem.add_dependency "thor"
  gem.add_dependency "guard"
  gem.add_dependency "rb-fsevent"
  gem.add_dependency "guard-cloudformation"
  gem.add_dependency "guard-lono"
  gem.add_dependency "colorize"
  gem.add_dependency "hashie"
  gem.add_dependency "aws-sdk", '~> 3'
  gem.add_dependency "activesupport"
  # gem.add_dependency "plissken" # dependency for vendor/lono-params
  # using the vendor fork version: https://github.com/tongueroo/plissken
  # until https://github.com/futurechimp/plissken/pull/6 gets merged

  gem.add_development_dependency "byebug"
  gem.add_development_dependency "guard-bundler"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
