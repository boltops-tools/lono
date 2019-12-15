class Lono::Sets
  class Delete
    include Lono::AwsServices
    include Lono::Sets::Summarize
    include Lono::Utils::Sure

    def initialize(options={})
      @options = options
      @stack = options.delete(:stack)
    end

    def run
      message = "Deleting #{@stack} stack set."
      if @options[:noop]
        puts "NOOP #{message}"
      else
        sure?("Are you sure you want to delete the #{@stack} stack set?", "Be sure that it emptied of stack instances first.")

        if stack_set_exists?(@stack)
          cfn.delete_stack_set(stack_set_name: @stack) # resp is an Empty structure, so much get operation_id from status
          puts message
        else
          puts "#{@stack.inspect} stack set does not exist".color(:red)
          return
        end
      end

      return true if @options[:noop] || !@options[:wait]

      status = Status.new(@options)
      success = status.wait
      operation_id = status.operation_id # getting operation_id from status because cfn.delete_stack_set resp is an Empty structure
      summarize(operation_id)
      exit 1 unless success

    rescue Aws::CloudFormation::Errors::StackSetNotEmptyException => e
      puts "ERROR: #{e.class}: #{e.message}".color(:red)
      puts <<~EOL
        The stack set must be empty before deleting. Cannot delete stack set until all stack instances are first
        deleted. If you want to delete all stack instances you can use:

            lono sets instances delete #{@stack} --all

      EOL
    end
  end
end
