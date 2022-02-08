module Lono::Inspector
  class Summary < Base
    include Lono::Cfn::Concerns::TemplateOutput

    def perform(template)
      # little dirty but @template is used in data method so we dont have to pass it to the data method
      @template = template

      logger.info "=> CloudFormation Template Summary for template #{@template.color(:sienna)}:"
      return if ENV['LONO_NOOP']

      print_parameters_summary
      logger.info "# Resources:"
      print_resource_types
    end

    def print_parameters_summary
      parameters = template_output.parameters
      parameter_groups = template_output.parameter_groups

      if parameters.empty?
        logger.info "There are no parameters in this template."
        return
      end

      shown = []
      logger.info "# Parameters Total (#{parameters.size})"
      parameter_groups.each do |label, parameters|
        logger.info "# Parameter Group (#{parameters.size}): #{label}".color(:sienna)
        parameters.each do |name|
          logger.info parameter_line(name)
          shown << name
        end
      end if parameter_groups

      parameters.each do |name, data|
        logger.info parameter_line(name) unless shown.include?(name)
      end
    end

    def parameter_line(name)
      data = template_output.parameters[name]
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
      resources = template_output.data["Resources"]
      return unless resources

      types = Hash.new(0)
      resources.each do |logical_id, resource|
        types[resource["Type"]] += 1
      end
      types
    end

    def print_resource_types
      unless resource_types
        logger.info "No resources found."
        return
      end

      types = resource_types.sort_by {|r| r[1] * -1} # Hash -> 2D Array
      types.each do |a|
        type, count = a
        printf "%3s %s\n", count, type
      end
      total = types.inject(0) { |sum,(type,count)| sum += count }
      printf "%3s %s\n", total, "Total"
    end

    def template_output
      Lono::Builder::Template::Output.new(@blueprint)
    end
    memoize :template_output
  end
end
