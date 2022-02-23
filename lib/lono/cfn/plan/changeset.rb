class Lono::Cfn::Plan
  class Changeset < Base
    # used by deploy to see whether or not to continue and bypass sure prompt
    attr_reader :changed
    alias_method :changed?, :changed

    # Override run from Base superclass, the run method is different enough with Preview
    def create
      @build.all
      @changed = false
      logger.info "Change Set Changes:".color(:green) if Lono.config.plan.changeset
      preview_change_set
      logger.info "" # newline
    end

    def display_changes(change_set)
      options = {change_set: change_set, blueprint: @blueprint, stack: @stack}
      Tags.new(options).changes
      Outputs.new(options).changes
      Resources.new(options).changes
      Notifications.new(options).changes
    end

    def preview_change_set
      create_change_set
      change_set = wait_for_change_set
      @changed = change_set.status == "CREATE_COMPLETE"
      handle_out(change_set)
      display(change_set)
    end

    def wait_for_change_set
      change_set = describe_change_set
      newline_needed = false
      until change_set_finished?(change_set) do
        change_set = describe_change_set
        sleep 1
        unless newline_needed
          logger.print "Determining Change Set"
        end
        newline_needed = true
        logger.print '.'
      end
      logger.print "\n" if newline_needed
      change_set
    end

    def create_change_set
      unless stack_exists?(@stack)
        logger.info "WARN: Cannot create a change set for the stack because the #{@stack} does not exists.".color(:yellow)
        return false
      end
      operable.check!

      options = {
        change_set_name: change_set_name,
        stack_name: @stack,
        parameters: @build.parameters,
      }

      opts = Lono::Cfn::Deploy::Opts.new(@blueprint, "create_change_set", @iam, options)
      opts.show
      options = opts.values

      begin
        # Tricky for preview need to set capabilities so that it gets updated. For Base#run save within the begin block already.
        options[:capabilities] = iam.capabilities # ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
        resp = cfn.create_change_set(options)
      rescue Aws::CloudFormation::Errors::InsufficientCapabilitiesException => e
        # If coming from cfn_preview_command automatically add iam capabilities
        cfn_preview_command = ARGV.join(" ").include?("cfn preview")
        if cfn_preview_command
          # e.message is "Requires capabilities : [CAPABILITY_IAM]"
          # grab CAPABILITY_IAM with regexp
          capabilities = e.message.match(/\[(.*)\]/)[1]
          @options.merge!(capabilities: [capabilities])
          retry
        end
        yes = iam.rerun?(e)
        @options = iam.options
        retry if yes
      end
    end

    def display(change_set)
      return unless Lono.config.plan.changeset
      case change_set.status
      when "CREATE_COMPLETE"
        display_changes(change_set)
      when "FAILED"
        logger.info "No changes"
        logger.debug change_set.status_reason # The submitted information didn't contain changes. Submit different information to create a change set.
      else
        raise "hell: never come here"
      end
      change_set
    end

    def execute_change_set
      return unless @changed
      cfn.execute_change_set(
        change_set_name: change_set_name,
        stack_name: @stack
      )
    end

    # generates a change set name
    def change_set_name
      @change_set_name ||= "changeset-#{Time.now.strftime("%Y%d%m%H%M%S")}"
    end

  private
    def change_set_finished?(change_set)
      change_set.status =~ /_COMPLETE/ || change_set.status == "FAILED"
    end

    def describe_change_set
      cfn.describe_change_set(
        change_set_name: change_set_name,
        stack_name: @stack
      )
    end

    def handle_out(change_set)
      out = @options[:out]
      return unless out
      logger.info "Change Set ARN: #{change_set.change_set_id}"
      if change_set.status == "FAILED"
        logger.info "Note: #{change_set.status_reason}"
      end
      logger.info "Change Set info saved to #{out}"
      FileUtils.mkdir_p(File.dirname(out))
      IO.write(out, JSON.pretty_generate(change_set.to_h))
    end
  end
end
