# Refer to Lono::Sets::Status::Instance::Base for more detailed docs.
class Lono::Sets::Status::Instance
  class Deleted < Base
    def tail
      display_one
      Thread.new do
        loop!
      end
    end

    def loop!
      # resp.stack_instance.status : one of CURRENT, OUTDATED, INOPERABLE
      while true
        begin
          display_one
        rescue Aws::CloudFormation::Errors::StackInstanceNotFoundException
          say status_line(@stack_instance.account, @stack_instance.region, "DELETED")
          break
        end
        delay
      end
    end

    def display_one
      resp = describe_stack_instance
      stack_instance = resp.stack_instance
      show_instance(stack_instance)
      @shown << stack_instance
      resp
    end
  end
end
