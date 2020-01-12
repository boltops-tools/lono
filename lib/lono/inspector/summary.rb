module Lono::Inspector
  class Summary < Base
    delegate :required_parameters, :optional_parameters, :parameters, :parameter_groups, :data,
             to: :output_template

    def perform(template)
      # little dirty but @template is used in data method so we dont have to pass it to the data method
      @template = template

      puts "=> CloudFormation Template Summary for template #{@template.color(:sienna)}:"
      return if @options[:noop]

      print_parameters_summary
      puts "# Resources:"
      print_resource_types
    end

    def print_parameters_summary
      if parameters.empty?
        puts "There are no parameters in this template."
        return
      end

      shown = []
      puts "# Parameters Total (#{parameters.size})"
      parameter_groups.each do |label, parameters|
        puts "# Parameter Group (#{parameters.size}): #{label}"
        parameters.each do |name|
          puts parameter_line(name)
          shown << name
        end
      end if output_template.parameter_groups

      parameters.each do |name, data|
        puts parameter_line(name) unless shown.include?(name)
      end
    end

    def parameter_line(name)
      data = parameters[name]
      example = description_example(data["Description"])
      if data["Default"].nil?
        line = "#{name}=#{example} # (required)"
      else
        default = data["Default"]
        line = "# #{name}=#{default}"
        line = "#{line} # #{example}" if example
      end
      line
    end

    def description_example(description)
      default = ''
      return default unless description
      md = description.match(/(Example|IE): (.*)/)
      return default unless md
      md[2]
    end

    def resource_types
      resources = data["Resources"]
      return unless resources

      types = Hash.new(0)
      resources.each do |logical_id, resource|
        types[resource["Type"]] += 1
      end
      types
    end

    def print_resource_types
      unless resource_types
        puts "No resources found."
        return
      end

      types = resource_types.sort_by {|r| r[1] * -1} # Hash -> 2D Array
      types.each do |a|
        type, count = a
        printf "%3s %s\n", count, type
      end
      printf "%3s %s\n", resource_types.size, "Total"
    end

    def output_template
      Lono::Output::Template.new(@blueprint, @template)
    end
    memoize :output_template
  end
end
