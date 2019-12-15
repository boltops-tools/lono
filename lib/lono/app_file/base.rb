# Naming AppFile instead of File so we dont to use ::File for normal regular File class
module Lono::AppFile
  class Base < Lono::AbstractBase
    # What's needed for a Thor::Group or "Sequence". Gives us Thor::Actions commands like create_file
    # Must be included before `def initialize` as we override the Thor initialize
    include Thor::Actions
    include Thor::Base
    # Override Thor::Base initialize
    def initialize(options={})
      reinitialize(options)
      initialize_variables
    end

    def initialize_variables
    end

  private
    # Hack Thor to be able to dynamically set the source_paths at runtime instance methods
    def override_source_paths(*paths)
      # Using string with instance_eval because block doesnt have access to path at runtime.
      self.class.instance_eval %{
        def self.source_paths
          #{paths.flatten.inspect}
        end
      }
    end
  end
end
