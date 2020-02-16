module Lono::Configset::Strategy
  class Dsl < Base
    include Helpers
    include Syntax

    def initialize(options={})
      super
      @structure = {} # holds in memory the configset hash structure
      @current = "main" # current configset
      @tracked = []
    end

    def find_evaluation_path
      "#{@root}/lib/configset.rb"
    end

    def load
      evaluate_file(@evaluation_path)
      configsets = @configsets || @tracked.uniq
      configsets = ["main"] if configsets.empty?
      init = {"configSets" => {"default" => configsets}}.merge(@structure)
      full_structure = { "AWS::CloudFormation::Init" => init }
      full_structure.deep_stringify_keys!
    end
  end
end
