class Lono::Cfn
  class Update < Base
    # save_stack is the interface method
    def save_stack(params)
      update_stack(params)
    end

    # aws cloudformation update-stack --stack-name prod-hi-123456789 --parameters file://output/params/prod-hi-123456789.json --template-body file://output/prod-hi.json
    def update_stack(params)
      message = "Updating #{@stack_name} stack"
      if @options[:noop]
        puts "NOOP #{message}"
        return
      end

      deleted = delete_rollback_stack
      if deleted
        Create.new(@stack_name, @options).create_stack(params)
        return
      end

      unless stack_exists?(@stack_name)
        puts "Cannot update a stack because the #{@stack_name} does not exists."
        return
      end
      exit_unless_updatable!(stack_status(@stack_name))

      options = @options.merge(mute_params: true, mute_using: true, keep: true)
      # create new copy of preview when update_stack is called because of IAM retry logic
      changeset_preview = Lono::Cfn::Preview::Changeset.new(@stack_name, options)

      error = nil
      param_preview.run if @options[:param_preview]
      codediff_preview.run if @options[:codediff_preview]
      changeset_preview.run if @options[:changeset_preview]
      are_you_sure?(@stack_name, :update)

      if @options[:change_set] # defaults to this
        message << " via change set: #{changeset_preview.change_set_name}"
        changeset_preview.execute_change_set
      else
        standard_update(params)
      end
      puts message unless @options[:mute] || error
    end

    def standard_update(params)
      params = {
        stack_name: @stack_name,
        parameters: params,
        capabilities: capabilities, # ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
        disable_rollback: !@options[:rollback],
      }
      params[:tags] = tags unless tags.empty?
      set_template_body!(params)
      show_parameters(params, "cfn.update_stack")
      begin
        cfn.update_stack(params)
      rescue Aws::CloudFormation::Errors::ValidationError => e
        puts "ERROR: #{e.message}".red
        false
      end
    end

    def codediff_preview
      Lono::Cfn::Preview::Codediff.new(@stack_name, @options.merge(mute_params: true, mute_using: true))
    end
    memoize :codediff_preview

    def param_preview
      Lono::Cfn::Preview::Param.new(@stack_name, @options)
    end
    memoize :param_preview
  end
end