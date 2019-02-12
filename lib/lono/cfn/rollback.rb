class Lono::Cfn
  class Rollback
    extend Memoist
    include AwsService

    def initialize(stack_name)
      @stack_name = stack_name
    end

    def delete_stack
      stack = find_stack(@stack_name)
      if stack && rollback_complete?(stack)
        puts "Existing stack in ROLLBACK_COMPLETE state. Deleting stack before continuing."
        cfn.delete_stack(stack_name: @stack_name)
        status.wait
        status.reset
        true
      end
    end

    def status
      Lono::Cfn::Status.new(@stack_name)
    end
    memoize :status
  end
end