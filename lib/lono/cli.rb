require 'thor'

module Lono
  class CLI < Thor

    desc "init", "Setup lono project"
    long_desc "Sets up config/lono.rb"
    def init
      Lono::Task.init
    end

    desc "generate", "Generate the cloud formation templates"
    long_desc <<EOL
Examples:

1. lono generate

Builds the cloud formation templates files based on config/lono.rb and writes them to the output folder on the filesystem.
EOL
    method_option :clean, :type => :boolean, :aliases => "-c", :desc => "remove all output files before generating"
    def generate
      Lono::Task.generate(options.dup.merge(:verbose => true))
    end
  end
  
end