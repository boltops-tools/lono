module Lono::Cfn::Plan::Diff
  class Base
    include Lono::Utils::Logging
    include Lono::Utils::Pretty

    def initialize(options={})
      @options = options
    end
  end
end
