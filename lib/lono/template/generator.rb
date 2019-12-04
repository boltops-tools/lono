require "yaml"

class Lono::Template
  class Generator
    include Lono::Blueprint::Root

    def initialize(blueprint, options={})
      @blueprint, @options = blueprint, options.dup
      @template = @options[:template] || @blueprint
      Lono::ProjectChecker.check
      set_blueprint_root(@blueprint)
    end

    def run
      # Examples:
      #   Erb.new(b, options.dup).run
      #   Dsl.new(b, options.dup).run
      generator_class = "Lono::Template::#{template_type.classify}"
      generator_class = Object.const_get(generator_class)
      generator_class.new(@blueprint, @options).run
    end

    def template_type
      meta_config = "#{Lono.blueprint_root}/.meta/config.yml"
      data = YAML.load_file(meta_config)
      data["template_type"] || "dsl"
    end
  end
end
