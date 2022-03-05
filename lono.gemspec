# -*- encoding: utf-8 -*-
require_relative "lib/lono/version"

Gem::Specification.new do |spec|
  spec.authors       = ["Tung Nguyen"]
  spec.email         = ["tongueroo@gmail.com"]
  spec.summary       = "Lono: The CloudFormation Framework"
  spec.homepage      = "https://lono.cloud"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/boltops-tools/lono"
  spec.metadata["changelog_uri"] = "https://github.com/boltops-tools/lono/blob/master/CHANGELOG.md"

  vendor_files       = Dir.glob("vendor/**/*")
  gem_files          = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|docs)/})
  end
  spec.files         = gem_files + vendor_files
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features|docs)/})
  spec.name          = "lono"
  spec.require_paths = ["lib"]
  spec.version       = Lono::VERSION
  spec.license       = "Apache-2.0"

  spec.add_dependency "activesupport"
  spec.add_dependency "aws-mfa-secure"
  spec.add_dependency "aws-sdk-cloudformation"
  spec.add_dependency "aws-sdk-ec2" # lono seed
  spec.add_dependency "aws-sdk-iam" # lono seed
  spec.add_dependency "aws-sdk-s3"
  spec.add_dependency "aws-sdk-ssm"
  spec.add_dependency "aws_data"
  spec.add_dependency "bundler", ">= 2"
  spec.add_dependency "cfn-status"
  spec.add_dependency "cfn_camelizer"
  spec.add_dependency "cli-format"
  spec.add_dependency "dsl_evaluator", ">= 0.2.5" # for DslEvaluator.print_code
  spec.add_dependency "filesize"
  spec.add_dependency "graph" # lono graph command dependency
  spec.add_dependency "hashie"
  spec.add_dependency "json"
  spec.add_dependency "memoist"
  spec.add_dependency "parslet"
  spec.add_dependency "plissken"
  spec.add_dependency "rainbow"
  spec.add_dependency "rb-fsevent"
  spec.add_dependency "render_me_pretty"
  spec.add_dependency "rexml"
  spec.add_dependency "text-table"
  spec.add_dependency "thor"
  spec.add_dependency "zeitwerk"
  # spec.add_dependency "rspec-lono"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "cli_markdown"
  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
