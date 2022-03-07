class Lono::CLI
  class Summary < Base
    include Lono::Cfn::Concerns::Build
    include Lono::Cfn::Concerns::TemplateOutput

    def run
      build.all
      print_parameters_summary
      print_resource_types
    end

    def print_parameters_summary
      parameters = template_output.parameters
      logger.info "Parameters (#{parameters.size})".color(:green)
      parameter_groups = template_output.parameter_groups

      if parameters.empty?
        logger.info "No parameters"
        return
      end

      shown = []
      parameter_groups.each do |parameter_group_label, parameters|
        logger.info parameter_group_label
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
      if data["Default"].nil?
        line = "    #{name} (required)"
      else
        default = data["Default"]
        line = default.blank? ? "    #{name}" : "    #{name}=#{default}"
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

    def print_resource_types
      total = template_output.data["Resources"].size
      logger.info "Resources (#{total})".color(:green)
      unless resource_types
        logger.info "No resources found."
        return
      end

      types = resource_types.sort_by {|r| r[1] * -1} # Hash -> 2D Array
      types.each do |a|
        type, count = a
        printf "%5s %s\n", count, type
      end
      total = types.inject(0) { |sum,(type,count)| sum += count }
      printf "%5s %s\n", total, "Total"
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
  end
end
