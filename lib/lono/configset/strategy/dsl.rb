module Lono::Configset::Strategy
  class Dsl < Base
    # Configset helpers take higher precedence than Lono DSL Helpers. IE: s3_key is overwritten but s3_bucket is the same
    include Helpers::Dsl

    def initialize(options={})
      super
      @structure = {} # holds in memory the configset hash structure to build AWS::CloudFormation::Init
      @current = "main" # current configset
      @command_counts = Hash.new(0)
      @tracked = []
      # Also support ability to add AWS::CloudFormation::Authentication
      @authentication = nil # holds IAM policy info to build AWS::CloudFormation::Authentication
    end

    def find_evaluation_path
      "#{@root}/lib/configset.rb"
    end

    def load
      evaluate_file(@evaluation_path)
      configsets = @configsets || @tracked.uniq
      configsets = ["main"] if configsets.empty?
      configsets_structure = {"configSets" => {"default" => configsets}}.merge(@structure)
      full = { "AWS::CloudFormation::Init" => configsets_structure }
      full.deep_stringify_keys!
    end
  end
end
