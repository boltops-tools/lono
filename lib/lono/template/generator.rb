require "yaml"

class Lono::Template
  class Generator < Lono::AbstractBase
    def run
      # Examples:
      #   Erb.new(options).run
      #   Dsl.new(options).run
      generator_class = "Lono::Template::Strategy::#{lono_strategy.camelize}"
      generator_class = Object.const_get(generator_class)
      generator_class.new(@options).run
      # The generator strategy class writes template to disk. The inject_configsets reads it back from disk.
      # Leaving as-is instead of reading all in memory in case there's a reason.
      inject_configsets
    end

    def lono_strategy
      if @options[:source]
        "source"
      else
        jadespec = Lono::Jadespec.new(Lono.blueprint_root, "unknown") # abusing Jadespec to get lono_strategy
        jadespec.lono_strategy
      end
    end

    def inject_configsets
      Lono::Configset::Preparer.new(@options).run # register and materialize gems
      ConfigsetInjector.new(@options).run
    end
  end
end
