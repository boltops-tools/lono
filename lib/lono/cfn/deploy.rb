module Lono::Cfn
  class Deploy < Base
    def run
      start_message
      perform # create or update
      success = status.wait
      if success
        finish_message
        logger.info "" # newline
      end
      outputs
    end

    def perform
      build.all
      @action = create? ? "create" : "update"
      send(@action)
    rescue Aws::CloudFormation::Errors::InsufficientCapabilitiesException => e
      @sure = true
      yes = iam.rerun?(e)
      retry if yes
    rescue Aws::CloudFormation::Errors::ValidationError => e
      if e.message.include?("No updates") # No updates are to be performed.
        logger.info "WARN: #{e.message}".color(:yellow)
      elsif e.message.include?("UPDATE_ROLLBACK_FAILED") # https://amzn.to/2IiEjc5
        rollback.continue_update
      else
        logger.info "ERROR: #{e.message}".color(:red)
        quit 1
      end
    end

    def create
      plan.for_create
      @sure || sure?("Going to create stack #{@stack} with blueprint #{@blueprint.name}.")

      options = {
        stack_name: @stack,
        parameters: build.parameters,
      }
      opts = Opts.new(@blueprint, "create_stack", iam, options)
      opts.show
      options = opts.values
      cfn.create_stack(options)
    end

    def update
      if rollback.delete_stack
        create
        return
      end

      operable.check!
      changeset = plan.for_update
      !changeset.changed? || @sure || sure?("Are you sure you want to update the #{@stack} stack?")
      changeset.execute_change_set
    end

    def create?
      !stack_exists?(@stack)
    end

    def start_message
      action = self.class.to_s.split('::').last
      logger.info "#{action}ing #{@stack.color(:green)} stack"
    end

    def finish_message
      message = "#{@action.capitalize}d #{@stack.color(:green)} stack."
      logger.info message unless @options[:mute]
    end

    def outputs
      Output.new(@options).run
    end
  end
end
