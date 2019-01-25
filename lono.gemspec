# -*- encoding: utf-8 -*-
require_relative "lib/lono/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Tung Nguyen"]
  gem.email         = ["tongueroo@gmail.com"]
  gem.summary       = "Lono is a CloudFormation Framework Tool"
  gem.homepage      = "http://github.com/tongueroo/lono"

  vendor_files       = Dir.glob("vendor/**/*")
  gem_files          = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|docs)/})
  end
  gem.files         = gem_files + vendor_files
  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{^exe/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features|docs)/})
  gem.name          = "lono"
  gem.require_paths = ["lib"]
  gem.version       = Lono::VERSION
  gem.license       = "MIT"

  gem.add_dependency "activesupport"
  gem.add_dependency "aws-sdk-cloudformation"
  gem.add_dependency "aws-sdk-s3"
  gem.add_dependency "filesize"
  gem.add_dependency "graph" # lono graph command dependency
  gem.add_dependency "guard"
  gem.add_dependency "guard-cloudformation"
  gem.add_dependency "guard-lono"
  gem.add_dependency "hashie"
  gem.add_dependency "json"
  gem.add_dependency "memoist"
  gem.add_dependency "rainbow"
  gem.add_dependency "rb-fsevent"
  gem.add_dependency "render_me_pretty"
  gem.add_dependency "thor"
  # gem.add_dependency "plissken" # dependency for vendor/lono-params
  # using the vendor fork version: https://github.com/tongueroo/plissken
  # until https://github.com/futurechimp/plissken/pull/6 gets merged

  gem.add_development_dependency "byebug"
  gem.add_development_dependency "cli_markdown"
  gem.add_development_dependency "guard-bundler"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
