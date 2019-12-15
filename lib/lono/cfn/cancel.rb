class Lono::Cfn
  class Cancel
    include Lono::AwsServices
    include Lono::Utils::Sure

    def initialize(options={})
      @options = options
      @stack = options[:stack]
    end

    def run
      if @options[:noop]
        puts "NOOP Canceling #{@stack} stack"
        return
      end

      stack = find_stack(@stack)
      unless stack
        puts "The '#{@stack}' stack does not exist. Unable to cancel"
        exit 1
      end

      puts "Canceling updates to #{@stack}."
      puts "Current stack status: #{stack.stack_status}"
      if stack.stack_status == "CREATE_IN_PROGRESS"
        cfn.delete_stack(stack_name: @stack)
        puts "Canceling stack creation."
      elsif stack.stack_status == "UPDATE_IN_PROGRESS"
        cfn.cancel_update_stack(stack_name: @stack)
        puts "Canceling stack update."
        status.wait if @options[:wait]
      else
        puts "The stack is not in a state to that is cancelable: #{stack.stack_status}"
      end
    end

    def status
      @status ||= Status.new(@stack)
    end
  end
end
