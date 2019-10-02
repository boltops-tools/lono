require "fileutils"

module Lono
  class Configure
    include Blueprint::Root

    def initialize(blueprint, options)
      @blueprint, @options = blueprint, options
      @args = options[:args] # hash
    end

    def run
      blueprint_root = find_blueprint_root(@blueprint)
      unless blueprint_root
        puts "ERROR: Did not find blueprint: #{@blueprint}".color(:red)
        puts "Are you sure you specified the right blueprint?"
        Blueprint::List.available
        exit 1
      end

      configs_path = "#{blueprint_root}/setup/configs.rb"
      unless File.exist?(configs_path)
        puts "No #{configs_path} file found.  Nothing to configure."
        exit
      end

      require configs_path
      unless defined?(Configs)
        puts "Configs class not found.\nAre you sure #{configs_path} contains a Configs class?"
        exit 1
      end
      configs = Configs.new(@blueprint, @options)
      # The Configs class implements: setup, params, and variables
      configs.run # setup the instance variables
    end
  end
end