class Lono::Sets
  class Delete
    include Lono::AwsServices
    include Lono::Sets::Summarize
    include Lono::Utils::Sure

    def initialize(options={})
      @options = options
      @stack = options[:stack]
    end

    def run
      message = "Deleting #{@stack} stack set."
      if @options[:noop]
        puts "NOOP #{message}"
      else
        desc =<<~EOL
          Be sure that the emptied StackSet instances is emptied first.
          You can empty it with a separate command: lono set_instances delete #{@stack} --all
          This command will only delete the StackSet itself after its been emptied.
        EOL
        sure?("Are you sure you want to delete the #{@stack} stack set?", desc)

        if stack_set_exists?(@stack)
          cfn.delete_stack_set(stack_set_name: @stack) # resp is an Empty structure, so must get operation_id from status
          puts message
        else
          puts "#{@stack.inspect} stack set does not exist".color(:red)
          return
        end
      end
    rescue Aws::CloudFormation::Errors::StackSetNotEmptyException => e
      puts "ERROR: #{e.class}: #{e.message}".color(:red)
      puts <<~EOL
        The stack set must be empty before deleting. Cannot delete stack set until all stack instances are first
        deleted. If you want to delete all stack instances you can use:

            lono set_instances delete #{@stack} --all

      EOL
    end
  end
end
