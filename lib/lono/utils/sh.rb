module Lono::Utils
  module Sh
    def sh(command, options={})
      on_fail = options[:on_fail].nil? ? "raise" : options[:on_fail]
      strategy = options[:strategy].nil? ? "system" : options[:strategy] # system or backticks

      logger.info "=> #{command}"

      if strategy == "backticks"
        out = `#{command}`
        logger.debug out
        success = $?.success?
      else
        success = system(command)
      end

      result = strategy == "backticks" ? out : success
      return result if success

      logger.error "ERROR: Running #{command}"
      case on_fail.to_sym
      when :raise
        raise
      when :exit
        status = $?.exitstatus
        exit status
      end

      result
    end
  end
end
