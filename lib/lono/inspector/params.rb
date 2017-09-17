class Lono::Inspector::Params < Lono::Inspector::Base
  def perform
    puts "Parameters Summary:"
    return if @options[:noop]

    print_parameters("Required", required_parameters)
    print_parameters("Optional", optional_parameters)
  end

  def print_parameters(label, parameters)
    puts "#{label}:"
    if parameters.empty?
      puts "  There are no #{label.downcase} parameters"
    else
      parameters.each do |logical_id, p|
        puts "  #{logical_id}"
      end
    end
  end

  def required_parameters
    data["Parameters"].select { |logical_id, p| p["Default"] }
  end

  def optional_parameters
    data["Parameters"].reject { |logical_id, p| p["Default"] }
  end
end
