require "yaml"

class Lono::Template
  class Generator < Lono::AbstractBase
    def run
      # Examples:
      #   Erb.new(b, options.dup).run
      #   Dsl.new(b, options.dup).run
      generator_class = "Lono::Template::Strategy::#{template_type.camelize}"
      generator_class = Object.const_get(generator_class)
      generator_class.new(@options).run
      # The generator strategy class writes template to disk. The inject_configsets reads it back from disk.
      # Leaving as-is instead of reading all in memory in case there's a reason.
      inject_configsets
    end

    def template_type
      if @options[:source]
        "source"
      else
        jadespec = Lono::Jadespec.new(Lono.blueprint_root, "unknown") # abusing Jadespec to get template_type
        jadespec.template_type
      end
    end

    def inject_configsets
      Lono::Configset::Preparer.new(@options).run # register and materialize gems
      ConfigsetInjector.new(@options).run
    end
  end
end
