# Encapsulates helper methods and instance variables to be rendered in the ERB templates.
module Lono::Builder
  class Context < Lono::CLI::Base
    extend Memoist
    include Lono::Builder::Template::Helpers
    include Loader
    include Helpers # ERB
    include Template::Dsl::Evaluator::Syntax # DSL
    include Lono::Utils::Context

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
