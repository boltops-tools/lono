# Encapsulates helper methods and instance variables to be rendered in the ERB
# templates.
class Lono::Template
  class Context
    include Lono::Template::Helper

    def initialize(options={})
      @options = options
      load_variables
      load_project_helpers
    end

    # Take a hash and makes them instance variables in the current scope.
    # Use this in custom helper methods to make variables accessible to ERB templates.
    def instance_variables!(variables)
      variables.each do |key, value|
        instance_variable_set('@' + key.to_s, value)
      end
    end

  private
    # Variables in base.rb are overridden by their environment specific variables
    # file.  Example, for LONO_ENV=development:
    #
    #   config/variables/base.rb
    #   config/variables/development.rb - will override any variables in base.rb
    #
    def load_variables
      load_variables_for("base")
      load_variables_for(Lono.env)
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

    # Load the variables defined in config/variables/* to make available in the
    # template blocks in config/templates/*.
    #
    # Example:
    #
    #   `config/variables/base.rb`:
    #     @foo = 123
    #
    #   `app/stacks/base.rb`:
    #      template "mytemplate.yml" do
    #        source "mytemplate.yml.erb"
    #        variables(foo: @foo)
    #      end
    #
    # NOTE: Only able to make instance variables avaialble with instance_eval,
    #   wasnt able to make local variables available.
    def load_variables_for(name)
      path = "#{Lono.config.variables_path}/#{name}.rb"
      instance_eval(IO.read(path))
    end
  end
end
