class Lono::Cfn
  class Cancel
    include Lono::AwsServices
    include Util

    def initialize(stack_name, options={})
      @stack_name = switch_current(stack_name)
      @options = options
    end

    def run
      stack = find_stack(@stack_name)
      unless stack
        puts "The '#{@stack_name}' stack does not exist. Unable to cancel"
        exit 1
      end

      puts "Canceling updates to #{@stack_name}."
      puts "Current stack status: #{stack.stack_status}"
      if stack.stack_status == "CREATE_IN_PROGRESS"
        cfn.delete_stack(stack_name: @stack_name)
        puts "Canceling stack creation."
      elsif stack.stack_status == "UPDATE_IN_PROGRESS"
        cfn.cancel_update_stack(stack_name: @stack_name)
        puts "Canceling stack update."
        status.wait if @options[:wait]
      else
        puts "The stack is not in a state to that is cancelable: #{stack.stack_status}"
      end
    end

    def status
      @status ||= Status.new(@stack_name)
    end
  end
end
