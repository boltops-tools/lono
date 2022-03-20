class Lono::Builder::Configset::Definition
  class Base < Lono::CLI::Base
    include DslEvaluator
    include Lono::Builder::Dsl::Syntax
    include Lono::Utils::Pretty
    include Context

    # Really only use @path in Configset DSL and ERB evaluation.
    # However, configsets are built within the CloudFormation template and can use
    # things instrinic functions like `ref` like would normally have access to.
    # So configsets need the same context
    #
    #     Configset::Definition::Base < Lono::CLI::Base
    #
    # for
    #
    #     include Lono::Builder::Dsl::Syntax
    #
    def initialize(options={})
      super
      @meta = @options[:meta]
      @configset = Lono::Configset.new(@meta)
      expose_instance_variables
    end

    # This context is used by the DSL evaluation. Expose variables so user can use them in configset definitions.
    # Example:
    #
    # "/etc/cfn/hooks.d/cfn-auto-reloader.conf":
    #   content:
    #     Fn::Sub:
    # ...
    #       path=Resources.<%= @resource %>.Metadata.AWS::CloudFormation::Init
    #
    def expose_instance_variables
      @name = @meta[:name]
      @resource = @meta[:resource]
    end

    def wrap_with_metadata(cloudformation_init)
      full = {"Metadata" => {}}
      full["Metadata"]["AWS::CloudFormation::Init"] = cloudformation_init["AWS::CloudFormation::Init"]
      full["Metadata"]["AWS::CloudFormation::Authentication"] = authentication if authentication # only on dsl
      full.deep_stringify_keys.dup # metadata
    end
  end
end
