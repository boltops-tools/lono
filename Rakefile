require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :spec

RSpec::Core::RakeTask.new

require_relative "lib/lono"
desc "Generates cli reference docs as markdown"
task :docs do
  Lono::Markdown::Creator.create_all(Lono::CLI)
end
