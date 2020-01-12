module Lono::Template::Strategy::Dsl::Builder::Helpers
  module LookupHelper
    extend Memoist
    include Lono::AwsServices

    def lookup_output(name)
      stack_name, key = name.split(".")
      resp = describe_stacks(stack_name: stack_name)
      stack = resp.stacks.first
      if stack
        o = stack.outputs.detect { |h| h.output_key == key }
      end

      if o
        o.output_value
      else
        "NOT FOUND: Did not lookup_output #{name} for stack #{stack}"
      end
    end

  private
    def describe_stacks(options={})
      cfn.describe_stacks(options)
    end
    memoize :describe_stacks
  end
end
