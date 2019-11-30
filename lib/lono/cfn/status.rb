class Lono::Cfn
  class Status < CfnStatus
    include Util

    def initialize(stack_name, options={})
      super
      @stack_name = switch_current(stack_name)
    end

    def switch_current(stack_name)
      Lono::Cfn::Current.name!(stack_name)
    end
  end
end
