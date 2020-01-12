module Lono::AwsServices
  module Helper
    include Stack
    include StackSet

    def rollback_complete?(stack)
      stack&.stack_status == 'ROLLBACK_COMPLETE'
    end

    def testing_update?
      ENV['LONO_TEST'] && self.class.name == "LonoCfn::Update"
    end
  end
end
