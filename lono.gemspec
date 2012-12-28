# -*- encoding: utf-8 -*-
require File.expand_path('../lib/lono/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tung Nguyen"]
  gem.email         = ["tongueroo@gmail.com"]
  gem.description   = %q{Lono is a Cloud Formation Template ruby generator.  Lono generates Cloud Formation templates based on ERB templates.}
  gem.summary       = %q{Lono is a Cloud Formation Template ruby generator.  Lono generates Cloud Formation templates based on ERB templates.}
  gem.homepage      = "http://github.com/tongueroo/lono"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "lono"
  gem.require_paths = ["lib"]
  gem.version       = Lono::VERSION

  gem.add_dependency "rake"
  gem.add_dependency "json"
  gem.add_dependency "thor"
  gem.add_dependency "aws-sdk"
  gem.add_dependency 'guard'
  gem.add_dependency 'rb-fsevent'
  gem.add_dependency "guard-cloudformation"
  gem.add_dependency "guard-lono"

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'guard-bundler'

end