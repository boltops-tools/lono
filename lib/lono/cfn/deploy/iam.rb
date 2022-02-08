class Lono::Cfn::Deploy
  class Iam < Base
    attr_reader :options

    def rerun?(e)
      # e.message is "Requires capabilities : [CAPABILITY_IAM]"
      # grab CAPABILITY_IAM with regexp
      capabilities = e.message.match(/\[(.*)\]/)[1]
      confirm = prompt(capabilities)
      if confirm =~ /^y/
        logger.info "Re-running: #{command_with_iam(capabilities).color(:green)}"
        @retry_capabilities = [capabilities]
        true
      else
        logger.info "Exited"
        quit 1
      end
    end

    def prompt(capabilities)
      logger.info <<~EOL
        This stack will create IAM resources.  Please approve to run the command again with #{capabilities} capabilities.

            #{command_with_iam(capabilities)}

        You can also avoid this prompt with config.up.capabilities in config/app.rb.
        See: https://lono.cloud/docs/config/reference/

      EOL
      logger.print "Please confirm (y/N) "
      $stdin.gets
    end

    def command_with_iam(capabilities)
      "lono #{Lono.argv.join(' ')} --capabilities #{capabilities}"
    end

    def capabilities
      return @retry_capabilities if @retry_capabilities
      return @options[:capabilities] if @options[:capabilities]
      if @options[:iam]
        ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
      else
        Lono.config.up.capabilities
      end
    end
  end
end

