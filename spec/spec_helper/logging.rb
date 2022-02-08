module SpecHelper
  module Logging
    # Should be called by before(:each)
    def override_logger
      @logs ||= StringIO.new
      logger = Lono::Logger.new(@logs)
      Lono.logger = logger
    end

    # Should be called by after(:each)
    def flush_overriden_logger
      @logs = StringIO.new
    end

    # stored logs
    def logs
      @logs.string
    end
  end
end
