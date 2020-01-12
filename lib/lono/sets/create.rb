class Lono::Sets
  class Create < Base
    def save
      message = "Creating #{@stack.color(:green)} stack set."
      if @options[:noop]
        puts "NOOP #{message}"
        return
      end

      if stack_set_exists?(@stack)
        puts "Cannot create #{@stack.color(:green)} stack set because it already exists.".color(:red)
        return
      end

      unless File.exist?(template_path)
        puts "Cannot create #{@stack.color(:green)} template not found: #{template_path}."
        return
      end

      options = build_options
      show_options(options, "cfn.create_stack_set")

      sure?("Are you sure you want to create the #{@stack} stack set?")

      cfn.create_stack_set(options) # resp.stack_set_id => String. There is no resp.operation_id
      puts message unless @options[:mute]
      true # There is no resp.operation_id
    end
  end
end