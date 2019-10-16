class Lono::Script
  class Base
    SCRIPTS_INFO_PATH = "#{Lono.config.output_path}/data/scripts_info.txt"
    include Lono::Blueprint::Root

    def initialize(blueprint, options={})
      @blueprint, @options = blueprint, options
      @template = @options[:template] || @blueprint
      Lono::ProjectChecker.check
      set_blueprint_root(@blueprint)
      Lono::ProjectChecker.empty_templates
    end
  end
end
