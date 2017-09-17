class Lono::Inspector::Params
  def initialize(stack_name, options)
    @stack_name = stack_name
    @options = options
  end

  def run
    puts "Parameters Summary"
  end
end
