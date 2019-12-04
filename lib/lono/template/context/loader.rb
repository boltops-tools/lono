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
      options = @options.clone
      options[:blueprint] = @blueprint
      options[:stack] ||= @blueprint
      location = Lono::ConfigLocation.new("variables", options, Lono.env)
      path = location.lookup
      evaluate_variables_file(path)
    end

    # Load the variables defined in config/variables/* to make available in the
    # template blocks in config/templates/*.
    #
    # Example:
    #
    #   `config/variables/base.rb`:
    #     @foo = 123
    #
    #   `app/definitions/base.rb`:
    #      template "mytemplate.yml" do
    #        source "mytemplate.yml.erb"
    #        variables(foo: @foo)
    #      end
    #
    # NOTE: Only able to make instance variables avaialble with instance_eval,
    #   wasnt able to make local variables available.
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