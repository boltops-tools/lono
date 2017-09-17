class Lono::Inspector::Depends
  def initialize(stack_name, options)
    @stack_name = stack_name
    @options = options
  end

  def run
    puts "CloudFormation Dependencies"
  end
end
