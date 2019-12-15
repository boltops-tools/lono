# Encapsulates helper methods and instance variables to be rendered in the ERB templates.
class Lono::Template
  class Context < Lono::AbstractBase
    extend Memoist
    include Lono::Template::Helper
    include Loader
    include Helpers # ERB
    include Strategy::Dsl::Builder::Syntax # DSL

    def initialize(options={})
      super
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

    # For Lono::AppFile::Build usage of Thor::Action directory
    # For some reason a send(:binding) doesnt work but get_binding like this works.
    def get_binding
      binding
    end
  end
end
