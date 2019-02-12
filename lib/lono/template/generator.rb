require "yaml"

class Lono::Template
  class Generator
    include Lono::Blueprint::Root

    def initialize(blueprint, options={})
      @blueprint, @options = blueprint, options
      @template = @options[:template] || @blueprint
      Lono::ProjectChecker.check
      set_blueprint_root(@blueprint)
    end

    def run
      # Examples:
      #   Erb.new(b, options.clone).run
      #   Dsl.new(b, options.clone).run
      generator_class = "Lono::Template::#{template_type.classify}"
      generator_class = Object.const_get(generator_class)
      generator_class.new(@blueprint, @options.clone).run
    end

    def template_type
      dot_lono = "#{Lono.blueprint_root}/.lono/config.yml"
      data = YAML.load_file(dot_lono)
      data["template_type"] || "dsl"
    end
  end
end
