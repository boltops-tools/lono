require "yaml"

class Lono::Cfn::Create < Lono::Cfn::Base
  # save_stack is the interface method
  def save_stack(params)
    create_stack(params)
  end

  # aws cloudformation create-stack --stack-name prod-hi-123456789 --parameters file://output/params/prod-hi-123456789.json --template-body file://output/prod-hi.json
  def create_stack(params)
    message = "Creating #{@stack_name.color(:green)} stack."
    if @options[:noop]
      puts "NOOP #{message}"
      return
    end

    if stack_exists?(@stack_name)
      puts "Cannot create #{@stack_name.color(:green)} stack because it already exists.".color(:red)
      return
    end

    unless File.exist?(@template_path)
      puts "Cannot create #{@stack_name.color(:green)} template not found: #{@template_path}."
      return
    end

    params = {
      stack_name: @stack_name,
      parameters: params,
      capabilities: capabilities, # ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
      disable_rollback: !@options[:rollback],
      tags: tags,
    }
    set_template_body!(params)

    show_parameters(params, "cfn.create_stack")
    cfn.create_stack(params)
    puts message unless @options[:mute]
  end
end
