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
      case e.message
      when /No updates/ # No updates are to be performed.
        logger.info "WARN: #{e.message}".color(:yellow)
      when /UPDATE_ROLLBACK_FAILED/ # https://amzn.to/2IiEjc5
        rollback.continue_update
      when /YAML not well-formed/ # happens if a value is a serialize Ruby Object. See: https://gist.github.com/tongueroo/737531d0bc8c92d92b5cd00493e15d9e
        # e.message: Template format error: YAML not well-formed. (line 207, column 9)
        print_code(e)
      else
        logger.info "ERROR: #{e.message}".color(:red)
        logger.info "Check: #{pretty_path(@blueprint.output_path)}"
        quit 1
      end
    end

    def print_code(exception)
      md = exception.message.match(/line (\d+),/)
      line_number = md[1]
      logger.error "Template for debugging: #{pretty_path(@blueprint.output_path)}"
      if md
        DslEvaluator.print_code(@blueprint.output_path, line_number)
        exit 1
      else
        raise
      end
    end

    def create
      plan.for_create
      @sure || sure?("Going to create stack #{@stack} with blueprint #{@blueprint.name}.")
      upload_files
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
      upload_files
      changeset.execute_change_set
    end

    # Upload files right before create_stack or execute_change_set
    # Its better to upload here as part of a deploy vs a build
    # IE: lono build should try not to do a remote write to s3 if possible
    def upload_files
      # Files built and compressed in
      #     Lono::Builder::Dsl::Finalizer::Files::Build#build_files
      Lono::Files.files.each do |file| # using singular file, but is like a "file_list"
        file.upload
      end
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
