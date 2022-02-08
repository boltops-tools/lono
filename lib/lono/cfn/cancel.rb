module Lono::Cfn
  class Cancel < Base
    def run
      stack = find_stack(@stack)
      unless stack
        logger.info "The '#{@stack}' stack does not exist. Unable to cancel"
        quit 1
      end

      logger.info "Canceling updates to #{@stack}."
      logger.info "Current stack status: #{stack.stack_status}"
      if stack.stack_status == "CREATE_IN_PROGRESS"
        cfn.delete_stack(stack_name: @stack)
        logger.info "Canceling stack creation."
      elsif stack.stack_status == "UPDATE_IN_PROGRESS"
        cfn.cancel_update_stack(stack_name: @stack)
        logger.info "Canceling stack update."
        status.wait if @options[:wait]
      else
        logger.info "The stack is not in a state to that is cancelable: #{stack.stack_status}"
      end
    end
  end
end
