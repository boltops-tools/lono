module Lono::Builder::Context
  class Generic < Lono::CLI::Base
    include Lono::Builder::Dsl::Syntax

    # For Lono::AppFile::Build usage of Thor::Action directory
    # For some reason a send(:binding) doesnt work but get_binding like this works.
    def get_binding
      binding
    end
  end
end
