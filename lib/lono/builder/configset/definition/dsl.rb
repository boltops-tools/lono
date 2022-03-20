class Lono::Builder::Configset::Definition
  class Dsl < Base
    include Syntax

    def initialize(options={})
      super
      @current = "main" # current configset
      @tracked = []
      @structure = {} # holds in memory the configset hash structure to build AWS::CloudFormation::Init
      @command_counts = Hash.new(0)
      # Also support ability to add AWS::CloudFormation::Authentication
      @authentication = nil # holds IAM policy info to build AWS::CloudFormation::Authentication
    end

    def evaluate
      load_context
      evaluate_file(@configset.path)
      configsets = configsets || @tracked.uniq
      configsets = ["main"] if configsets.empty?
      configsets_structure = {"configSets" => {"default" => configsets}}.merge(@structure)
      cloudformation_init = { "AWS::CloudFormation::Init" => configsets_structure }
      wrap_with_metadata(cloudformation_init)
    end
  end
end
