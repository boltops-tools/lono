class Lono::Cfn
  class Delete
    include Lono::AwsServices
    include Util

    def initialize(stack_name, options={})
      @stack_name = switch_current(stack_name)
      @options = options
    end

    def run
      message = "Deleted #{@stack_name} stack."
      if @options[:noop]
        puts "NOOP #{message}"
      else
        are_you_sure?(@stack_name, :delete)

        if stack_exists?(@stack_name)
          cfn.delete_stack(stack_name: @stack_name)
          puts message
        else
          puts "#{@stack_name.inspect} stack does not exist".color(:red)
        end
      end

      return unless @options[:wait]
      start_time = Time.now
      status.wait unless @options[:noop]
      took = Time.now - start_time
      puts "Time took for stack deletion: #{status.pretty_time(took).color(:green)}."
    end

    def status
      @status ||= Status.new(@stack_name)
    end
  end
end