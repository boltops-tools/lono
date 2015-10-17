require 'thor'
require 'lono/cli/help'

module Lono
  class CLI < Thor

    desc "new [NAME]", "Generates lono starter project"
    Help.new_long_desc
    option :force, :type => :boolean, :aliases => "-f", :desc => "override existing starter files"
    option :quiet, :type => :boolean, :aliases => "-q", :desc => "silence the output"
    def new(project_root)
      Lono::New.new(options.clone.merge(:project_root => project_root)).run
    end

    desc "generate", "Generate the cloudformation templates"
    Help.generate
    option :clean, :type => :boolean, :aliases => "-c", :desc => "remove all output files before generating"
    option :project_root, :default => ".", :aliases => "-r", :desc => "project root"
    option :quiet, :type => :boolean, :aliases => "-q", :desc => "silence the output"
    option :pretty, :type => :boolean, :default => true, :desc => "json pretty the output"
    def generate
      Lono::DSL.new(options.clone).run
    end

    desc "bashify [URL-OR-PATH]", "Convert the UserData section of an existing CloudFormation Template to a starter bash script that is compatiable with lono"
    Help.bashify
    def bashify(path)
      Lono::Bashify.new(:path => path).run
    end

    desc "version", "Prints version"
    def version
      puts Lono::VERSION
    end

  end  
end
