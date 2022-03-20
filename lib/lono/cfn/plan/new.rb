class Lono::Cfn::Plan
  class New < Lono::Cfn::Base
    include Concerns

    def run
      if resource_types.empty?
        logger.info "ERROR: At least one Resource member must be defined in the template".color(:red)
        quit 1
      end

      logger.info "Will create".color(:green)
      summary.print(resource_types)
    end

    def resource_types
      resources = template_output.resources
      return {} unless resources

      types = Hash.new(0)
      resources.each do |logical_id, resource|
        types[resource["Type"]] += 1
      end
      types
    end
  end
end
