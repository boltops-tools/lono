class Lono::Template::Context
  module Loader
    include LoadFiles

    private
    # Not using Lono::Template::Context because that works differently.
    # That is used to load a context object that is passed to RenderMePretty's context.
    # So that we can load context for params files and erb templates.
    #
    # In this case builder is actually the dsl context.
    # We want to load variables and helpers into this builder context directly.
    # This loads additional context. It looks very similar to Lono::Template::Context
    def load_context
      load_variables
      load_helpers
    end

    # Variables in base.rb are overridden by their environment specific variables
    # file.  Example, file LONO_ENV=development:
    #
    #   config/variables/base.rb
    #   config/variables/development.rb - will override any variables in base.rb
    #
    def load_variables
      options = ActiveSupport::HashWithIndifferentAccess.new(@options.dup)
      options[:blueprint] = @blueprint
      options[:stack] ||= @blueprint
      layering = Lono::Layering.new("variables", options, Lono.env)
      layering.locations.each do |path|
        evaluate_variables_file(path)
      end
    end

    # Load the variables defined in config/variables/* to make available in lono scope.
    #
    # NOTE: Was only able to make instance variables avaialble with instance_eval, wasnt able to make local variables
    # available.
    def evaluate_variables_file(path)
      return unless File.exist?(path)
      instance_eval(IO.read(path), path)
    end

    # Load custom helper methods from project
    def load_helpers
      load_project_helpers # project helpers will override extension helpers
    end

    def load_project_helpers
      load_files(Lono.config.helpers_path)
    end
  end
end
