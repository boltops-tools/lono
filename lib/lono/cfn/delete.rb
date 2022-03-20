module Lono::Cfn
  class Delete < Base
    def run
      logger.info "Will delete stack #{@stack.color(:green)}"
      plan.for_delete
      sure?("Are you sure you want to delete the stack?")
      run_hooks("down") do
        cfn.delete_stack(stack_name: @stack)
      end
      if @options[:wait]
        status.wait
      else
        logger.info "Deleting stack #{@stack}"
      end
    end
  end
end