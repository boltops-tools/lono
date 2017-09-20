class Lono::Inspector::Summary < Lono::Inspector::Base
  def perform
    puts "CloudFormation Template Summary:".colorize(:green)
    return if @options[:noop]

    puts "Parameters:"
    print_parameters("Required", required_parameters)
    print_parameters("Optional", optional_parameters)

    puts "Resources:"
    print_resource_types
  end

  def print_parameters(label, parameters)
    puts "#{label}:"
    if parameters.empty?
      puts "  There are no #{label.downcase} parameters"
    else
      parameters.each do |logical_id, p|
        output = "  #{logical_id} (#{p["Type"]})"
        if p["Default"]
          output << " Default: #{p["Default"]}"
        end
        puts output
      end
    end
  end

  def required_parameters
    data["Parameters"].reject { |logical_id, p| p["Default"] }
  end

  def optional_parameters
    data["Parameters"].select { |logical_id, p| p["Default"] }
  end

  def resource_types
    types = Hash.new(0)
    data["Resources"].each do |logical_id, resource|
      types[resource["Type"]] += 1
    end
    types
  end

  def print_resource_types
    types = resource_types.sort_by {|r| r[1] * -1} # Hash -> 2D Array
    types.each do |a|
      type, count = a
      printf "%3s %s\n", count, type
    end
  end
end
