class Lono::Cfn::Delete
  include Lono::Cfn::AwsServices
  include Lono::Cfn::Util

  def initialize(stack_name, options={})
    @stack_name = stack_name
    @options = options
  end

  def run
    message = "Deleted #{@stack_name} stack."
    if @options[:noop]
      puts "NOOP #{message}"
    else
      are_you_sure?(:delete)

      if stack_exists?(@stack_name)
        cfn.delete_stack(stack_name: @stack_name)
        puts message
      else
        puts "#{@stack_name.inspect} stack does not exist".colorize(:red)
      end
    end
  end
end
