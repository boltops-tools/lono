# Naming AppFile instead of File so we dont to use ::File for normal regular File class
module Lono::AppFile
  class Base
    include Lono::Blueprint::Root
    extend Memoist

    def initialize(blueprint, options = {})
      @blueprint, @options = blueprint, options
      @template = @options[:template] || @blueprint
      Lono::ProjectChecker.check
      set_blueprint_root(@blueprint)
      Lono::ProjectChecker.empty_templates
      initialize_variables
    end

    def initialize_variables
    end
  end
end
