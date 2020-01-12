class Lono::Cfn
  class Update < Base
    # save is the interface method
    # aws cloudformation update-stack --stack-name prod-hi-123456789 --parameters file://output/params/prod-hi-123456789.json --template-body file://output/prod-hi.json
    def save(parameters)
      message = "Updating #{@stack} stack"
      if @options[:noop]
        puts "NOOP #{message}"
        return
      end

      deleted = delete_rollback_stack
      if deleted
        Create.new(@options).save(parameters)
        return
      end

      unless stack_exists?(@stack)
        puts "Cannot update a stack because the #{@stack} does not exists."
        return
      end
      exit_unless_updatable!

      options = @options.merge(mute_params: true, mute_using: true, keep: true)
      # create new copy of preview when update_stack is called because of IAM retry logic
      changeset_preview = Lono::Cfn::Preview::Changeset.new(options)

      param_preview.run if @options[:param_preview]
      codediff_preview.run if @options[:codediff_preview]
      changeset_preview.run if @options[:changeset_preview]
      sure?("Are you sure you want to update the #{@stack} stack?")

      if @options[:change_set] # defaults to this
        message << " via change set: #{changeset_preview.change_set_name}"
        changeset_preview.execute_change_set
      else
        standard_update(parameters)
      end
      puts message unless @options[:mute]
    end

    def standard_update(parameters)
      options = {
        stack_name: @stack,
        parameters: parameters,
        capabilities: capabilities, # ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
        disable_rollback: !@options[:rollback],
      }
      options[:tags] = tags unless tags.empty?
      set_template_url!(options)
      show_options(options, "cfn.update_stack")
      begin
        cfn.update_stack(options)
      rescue Aws::CloudFormation::Errors::ValidationError => e
        puts "ERROR: #{e.message}".color(:red)
        false
      end
    end

    def codediff_preview
      Lono::Cfn::Preview::Codediff.new(@options.merge(mute_params: true, mute_using: true))
    end
    memoize :codediff_preview

    def param_preview
      Lono::Cfn::Preview::Param.new(@options)
    end
    memoize :param_preview
  end
end