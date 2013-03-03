require 'thor'

module Lono
  class CLI < Thor

    desc "init", "Setup lono starter project"
    long_desc "Sets up config/lono.rb"
    method_option :force, :type => :boolean, :aliases => "-f", :desc => "override existing starter files"
    method_option :project_root, :default => ".", :aliases => "-r", :desc => "project root"
    method_option :quiet, :type => :boolean, :aliases => "-q", :desc => "silence the output"
    def init
      Lono::Task.init(options)
    end

    desc "generate", "Generate the cloud formation templates"
    long_desc <<EOL
Examples:

1. lono generate
2. lono g -c # shortcut

Builds the cloud formation templates files based on config/lono.rb and writes them to the output folder on the filesystem.
EOL
    method_option :clean, :type => :boolean, :aliases => "-c", :desc => "remove all output files before generating"
    method_option :project_root, :default => ".", :aliases => "-r", :desc => "project root"
    method_option :quiet, :type => :boolean, :aliases => "-q", :desc => "silence the output"
    def generate
      Lono::Task.generate(options)
    end
  end
  
end