source "https://rubygems.org"

# Specify your gem dependencies in lono.gemspec
gemspec

if ENV['C9_USER']
  gem "rspec-lono", path: "~/boltops-tools/rspec-lono"
else
  gem "rspec-lono", git: "https://github.com/boltops-tools/rspec-lono", branch: "master"
end
