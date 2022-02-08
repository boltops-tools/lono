module Lono::Cfn
  class Show < Base
    include Plan::Concerns

    def run
      logger.info "Info for stack: #{@stack.color(:green)}"
      logger.info "Resources:".color(:green)
      print
      Output.new(@options).run
    end

    def print
      summary.print(resource_types)
    end

    def resource_types
      resources = find_stack_resources(@stack)
      unless resources
        logger.info "ERROR: Stack #{@stack} not found".color(:red)
        exit 1
      end

      types = Hash.new(0)
      resources.each do |resource|
        types[resource.resource_type] += 1
      end
      types
    end
  end
end
