module Lono::Builder::Dsl::Helpers
  module Stack
    extend Memoist
    include Lono::AwsServices

    def stack_output(name)
      stack_name, key = name.split(".")
      stack_name = stack_name(stack_name)
      resp = describe_stacks(stack_name: stack_name)
      stack = resp.stacks.first
      if stack
        o = stack.outputs.detect { |h| h.output_key == key }
      end

      if o
        o.output_value
      else
        logger.info "WARN2: NOT FOUND: output #{key} for stack #{stack_name}"
        nil
      end
    end

    def stack_resource(name)
      stack_name, logical_id = name.split(".")
      stack_name = stack_name(stack_name)
      resp = describe_stack_resources(stack_name: stack_name)
      resources = resp.stack_resources
      resource = resources.find { |r| r.logical_resource_id == logical_id }
      if resource
        resource.physical_resource_id
      else
        logger.info "WARN: NOT FOUND: logical_id #{logical_id} for stack #{stack_name}"
        nil
      end
    end

    def stack_name(blueprint)
      return blueprint unless Lono.config.names.output.expand
      names = Lono::Names.new(blueprint: blueprint)
      # explicit expansion pattern provided by user
      pattern = blueprint.include?(':') ? blueprint : Lono.config.names.output.stack
      names.expansion(pattern)
    end

  private
    def describe_stacks(options={})
      cfn.describe_stacks(options)
    end
    memoize :describe_stacks

    def describe_stack_resources(options={})
      cfn.describe_stack_resources(options)
    end
    memoize :describe_stack_resources
  end
end
