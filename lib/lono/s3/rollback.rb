module Lono::S3
  class Rollback < Lono::Cfn::Deploy::Rollback
    # override initialize
    def initialize(stack)
      @stack = stack
    end
  end
end
