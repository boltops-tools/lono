module Lono::Template::Strategy::Dsl::Builder::Helpers
  module StackHelper
    extend Memoist
    include Lono::AwsServices

    def stack_output(name)
      stack_name, key = name.split(".")
      resp = describe_stacks(stack_name: stack_name)
      stack = resp.stacks.first
      if stack
        o = stack.outputs.detect { |h| h.output_key == key }
      end

      if o
        o.output_value
      else
        "NOT FOUND: output #{key} for stack #{stack_name}"
      end
    end

    def stack_resource(name)
      stack_name, logical_id = name.split(".")
      resp = describe_stack_resources(stack_name: stack_name)
      resources = resp.stack_resources
      resource = resources.find { |r| r.logical_resource_id == logical_id }
      if resource
        resource.physical_resource_id
      else
        "NOT FOUND: logical_id #{logical_id} for stack #{stack_name}"
      end
    end

    def lookup_output(name)
      result = stack_output(name)
      return unless ENV['LONO_DEPRECATION_SOFT']
      puts "DEPRECATION WARNING: lookup_output is deprecated. Please use stack_output instead".color(:yellow)
      result
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
