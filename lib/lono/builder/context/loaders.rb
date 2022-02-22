module Lono::Builder::Context
  module Loaders
    include LoadFiles

    # Variables in base.rb are overridden by their environment specific variables
    # file.  Example, file LONO_ENV=dev:
    #
    #   config/vars/base.rb
    #   config/vars/dev.rb - will override any variables in base.rb
    #   config/vars/base.rb
    #   config/vars/dev.rb - will override any variables in base.rb
    #
    def load_variables
      layers = Lono::Layering::Layer.new(@blueprint, "vars").paths
      layers.each do |layer|
        evaluate_variables_file(layer)
      end
    end

    # Load the variables defined in config/vars/* to make available in lono scope.
    #
    # NOTE: Was only able to make instance variables avaialble with instance_eval, wasnt able to make local variables
    # available.
    def evaluate_variables_file(path)
      return unless File.exist?(path)
      instance_eval(IO.read(path), path)
    end

    # Load blueprint helpers
    # blueprint helpers override extension helpers
    def load_blueprint_helpers
      load_files("#{@blueprint.root}/#{Lono.config.paths.helpers}")
    end
  end
end
