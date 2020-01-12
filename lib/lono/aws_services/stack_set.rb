module Lono::AwsServices
  module StackSet
    def stack_set_exists?(stack_set_name)
      return true if ENV['LONO_TEST']
      return false if @options[:noop]

      exist = nil
      begin
        # When the stack does not exist an exception is raised. Example:
        # Aws::CloudFormation::Errors::ValidationError: Stack with id blah does not exist
        cfn.describe_stack_set(stack_set_name: stack_set_name)
        exist = true
      rescue Aws::CloudFormation::Errors::StackSetNotFoundException => e
        if e.message =~ /not found/
          exist = false
        elsif e.message.include?("'stackName' failed to satisfy constraint")
          # Example of e.message when describe_stack with invalid stack name
          # "1 validation error detected: Value 'instance_and_route53' at 'stackName' failed to satisfy constraint: Member must satisfy regular expression pattern: [a-zA-Z][-a-zA-Z0-9]*|arn:[-a-zA-Z0-9:/._+]*"
          puts "Invalid stack name: #{stack_set_name}"
          puts "Full error message: #{e.message}"
          exit 1
        else
          raise # re-raise exception  because unsure what other errors can happen
        end
      end
      exist
    end

    def find_stack_set(stack_set_name)
      resp = cfn.describe_set_stack(stack_set_name: stack_set_name)
      resp.stack_set
    rescue Aws::CloudFormation::Errors::ValidationError => e
      # example: StackSet with id demo-web does not exist
      if e.message =~ /Stack/ && e.message =~ /does not exist/
        nil
      else
        raise
      end
    end
  end
end
