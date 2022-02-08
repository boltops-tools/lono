module Lono::Cfn
  class Delete < Base
    def run
      plan.for_delete
      sure?("Are you sure you want to delete the #{@stack} stack?")
      cfn.delete_stack(stack_name: @stack)
      if @options[:wait]
        status.wait
      else
        logger.info "Deleting stack #{@stack}"
      end
    end
  end
end