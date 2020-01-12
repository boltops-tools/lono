class Lono::Template::Context
  module Loader
    private
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
      location = Lono::ConfigLocation.new("variables", options, Lono.env)
      evaluate_variables_file(location.lookup_base) if location.lookup_base
      evaluate_variables_file(location.lookup) if location.lookup # config file
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
    def load_project_helpers
      Dir.glob("#{Lono.config.helpers_path}/**/*_helper.rb").each do |path|
        filename = path.sub(%r{.*/},'').sub('.rb','')
        module_name = filename.classify

        # Prepend a period so require works LONO_ROOT is set to a relative path
        # without a period.
        #
        # Example: LONO_ROOT=tmp/lono_project
        first_char = path[0..0]
        path = "./#{path}" unless %w[. /].include?(first_char)
        require path
        self.class.send :include, module_name.constantize
      end
    end
  end
end
