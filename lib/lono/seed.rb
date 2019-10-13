module Lono
  class Seed
    include Lono::Blueprint::Root
    include Lono::Conventions

    def initialize(blueprint, options={})
      @blueprint, @options = blueprint, options
      set_blueprint_root(@blueprint)
      @template, @param = template_param_convention(options)
    end

    def create
      puts "Creating starter config files for #{@blueprint}"
      configs_class = load_configs_class # ::Configs or Lono::Seed::Base
      configs = configs_class.new(@blueprint, @options)
      # The Configs class implements: variables
      configs.run # setup the instance variables
    end

  private
    def load_configs_class
      blueprint_root = find_blueprint_root(@blueprint)
      configs_path = "#{blueprint_root}/seed/configs.rb"

      begin
        loaded = load configs_path
      rescue LoadError
        loaded = false
      end

      if loaded
        if defined?(Lono::Seed::Configs)
          configs_class = Lono::Seed::Configs # blueprint specific Configs
        else
          puts "Configs class not found.\nAre you sure #{configs_path} contains a Configs class?"
          exit 1
        end
      else
        configs_class = Lono::Seed::Base # Generic handling
      end

      configs_class
    end
  end
end
