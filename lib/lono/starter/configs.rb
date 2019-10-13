class Lono::Starter
  class Configs
    include Lono::Blueprint::Root
    include Lono::Conventions

    def initialize(blueprint, options={})
      @blueprint, @options = blueprint, options
      set_blueprint_root(@blueprint)
      @template, @param = template_param_convention(options)
    end

    def create
      puts "Creating starter config files for #{@blueprint}"
      configs_class = load_configs_class # ::Configs or Lono::Starter::Base
      configs = configs_class.new(@blueprint, @options)
      # The Configs class implements: starter, params, and variables
      configs.run # setup the instance variables
    end

  private
    def load_configs_class
      blueprint_root = find_blueprint_root(@blueprint)
      configs_path = "#{blueprint_root}/starter/configs.rb"

      begin
        loaded = load configs_path
      rescue LoadError
        loaded = false
      end

      if loaded
        if defined?(::Configs)
          configs_class = ::Configs # blueprint specific Configs
        else
          puts "Configs class not found.\nAre you sure #{configs_path} contains a Configs class?"
          exit 1
        end
      else
        configs_class = Lono::Starter::Base # Generic Base
      end

      configs_class
    end
  end
end
