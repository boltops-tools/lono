class Lono::CLI
  class Status < Lono::CLI::Base
    include Lono::AwsServices

    def run
      names = Lono::Names.new(@options)
      stack = find_stack(@stack)
      if stack
        status = Lono::Cfn::Status.new(@stack, @options)
        success = status.run
        exit 1 unless success
      else
        logger.error "ERROR: stack #{@stack} not found".color(:red)
        exit 1
      end
    end
  end
end