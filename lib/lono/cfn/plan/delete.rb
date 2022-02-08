class Lono::Cfn::Plan
  class Delete < Lono::Cfn::Base
    include Concerns

    def run
      stack = find_stack(@stack)
      unless stack
        logger.info "ERROR: stack #{@stack} not found".color(:red)
        quit 1
      end

      logger.info "Will delete".color(:green)
      Lono::Cfn::Show.new(@options).print
    end
  end
end
