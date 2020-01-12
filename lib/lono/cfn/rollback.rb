class Lono::Cfn
  class Rollback
    extend Memoist
    include Lono::AwsServices

    def initialize(stack)
      @stack = stack
    end

    def delete_stack
      stack = find_stack(@stack)
      if stack && rollback_complete?(stack)
        puts "Existing stack in ROLLBACK_COMPLETE state. Deleting stack before continuing."
        cfn.delete_stack(stack_name: @stack)
        status.wait
        status.reset
        true
      end
    end

    def status
      Lono::Cfn::Status.new(@stack)
    end
    memoize :status
  end
end