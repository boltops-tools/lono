class Lono::Builder
  module Context
    include DslEvaluator

    def load_context
      load_variables
      load_helpers
    end

    # Variables in base.rb are overridden by their environment specific variables
    # file.  Example, file LONO_ENV=dev:
    #
    #   config/vars/base.rb
    #   config/vars/dev.rb - will override any variables in base.rb
    #   config/vars/base.rb
    #   config/vars/dev.rb - will override any variables in base.rb
    #
    def load_variables
      return if seed?
      layers = Lono::Layering::Layer.new(@blueprint, "vars").paths
      layers.each do |layer|
        evaluate_file(layer)
      end
    end

    # Load blueprint helpers
    # blueprint helpers override extension helpers
    def load_helpers
      load_helper_files("#{Lono.root}/vendor/helpers",   type: :project)
      load_helper_files("#{Lono.root}/app/helpers",   type: :project)
      load_helper_files("#{@blueprint.root}/helpers", type: :blueprint) # takes higher precedence
    end

    # Dont want any existing files to prevent building the blueprint.
    # This means that parameters cannot be based on vars. It's a trade-off.
    def seed?
      ARGV[0] == "seed"
    end
  end
end
