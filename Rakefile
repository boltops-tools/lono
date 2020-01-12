require "./lib/lono"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :spec

RSpec::Core::RakeTask.new

require_relative "lib/lono"
require "cli_markdown"
desc "Generates cli reference docs as markdown"
task :docs do
  CliMarkdown::Creator.create_all(cli_class: Lono::CLI, cli_name: "lono")
end
