module Lono::Bundler::Util
  module Git
    include Logging

    def sh(command)
      command = "#{command} 2>&1" # always need output for the sha
      logger.debug "=> #{command}"
      out = `#{command}`
      unless $?.success?
        if command.include?("git")
          raise LB::GitError.new("#{command}\n#{out}")
        else
          logger.error "ERROR: running #{command}".color(:red)
          logger.error out
          exit $?.exitstatus
        end
      end
      out
    end

    def git(command)
      sh("git #{command}")
    rescue LB::GitError => e
      action, version = command.split(' ')
      if action == "checkout" && version !~ /^v/
        command = "checkout v#{version}"
        retry
      else
        logger.error "ERROR: There was a git error".color(:red)
        logger.error "Current dir: #{Dir.pwd}"
        logger.error "The error occur when running:"
        logger.error e.message
      end
      exit 1
    end
  end
end
