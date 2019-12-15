require "yaml"

class Lono::Cfn
  class Create < Base
    # save is the interface method
    # aws cloudformation create-stack --stack-name prod-hi-123456789 --parameters file://output/params/prod-hi-123456789.json --template-body file://output/prod-hi.json
    def save(parameters)
      message = "Creating #{@stack.color(:green)} stack."
      if @options[:noop]
        puts "NOOP #{message}"
        return
      end

      delete_rollback_stack

      if stack_exists?(@stack)
        puts "Cannot create #{@stack.color(:green)} stack because it already exists.".color(:red)
        return
      end

      unless File.exist?(template_path)
        puts "Cannot create #{@stack.color(:green)} template not found: #{template_path}."
        return
      end

      options = {
        stack_name: @stack,
        parameters: parameters,
        capabilities: capabilities, # ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
        disable_rollback: !@options[:rollback],
      }
      options[:tags] = tags unless tags.empty?
      set_template_url!(options)

      show_options(options, "cfn.create_stack")
      cfn.create_stack(options) # TODO: COMMENT OUT FOR TESTING
      puts message unless @options[:mute]
    end
  end
end
