class Lono::Template
  class Base
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