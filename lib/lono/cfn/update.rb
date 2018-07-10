class Lono::Cfn::Update < Lono::Cfn::Base
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

    unless stack_exists?(@stack_name)
      puts "Cannot update a stack because the #{@stack_name} does not exists."
      return
    end
    exit_unless_updatable!(stack_status(@stack_name))

    options = @options.merge(lono: false, mute_params: true, mute_using: true, keep: true)
    # create new copy of preview when update_stack is called because of IAM retry logic
    preview = Lono::Cfn::Preview.new(@stack_name, options)

    error = nil
    diff.run if @options[:diff]
    preview.run if @options[:preview]
    are_you_sure?(@stack_name, :update)

    if @options[:change_set] # defaults to this
      message << " via change set: #{preview.change_set_name}"
      preview.execute_change_set
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
    set_template_body!(params)
    show_parameters(params, "cfn.update_stack")
    begin
      cfn.update_stack(params)
    rescue Aws::CloudFormation::Errors::ValidationError => e
      puts "ERROR: #{e.message}".red
      error = true
    end
  end

  def diff
    @diff ||= Lono::Cfn::Diff.new(@stack_name, @options.merge(lono: false, mute_params: true, mute_using: true))
  end
end
