class Lono::Cfn::Create < Lono::Cfn::Base
  # save_stack is the interface method
  def save_stack(params)
    create_stack(params)
  end

  # aws cloudformation create-stack --stack-name prod-hi-123456789 --parameters file://output/params/prod-hi-123456789.json --template-body file://output/prod-hi.json
  def create_stack(params)
    message = "Creating #{@stack_name} stack."
    if @options[:noop]
      puts "NOOP #{message}"
      return
    end

    if stack_exists?(@stack_name)
      puts "Cannot create '#{@stack_name}' stack because it already exists."
      return
    end

    unless File.exist?(@template_path)
      puts "Cannot create '#{@stack_name}' template not found: #{@template_path}."
      return
    end

    template_body = IO.read(@template_path)
    cfn.create_stack(
      stack_name: @stack_name,
      template_body: template_body,
      parameters: params#,
      # capabilities: ["CAPABILITY_IAM"]
    )
    puts message unless @options[:mute]
  end
end
