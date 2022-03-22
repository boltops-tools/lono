class Lono::Cfn::Deploy
  class Operable < Base
    def check!
      status = stack_status
      unless status =~ /_COMPLETE$/ || status == "UPDATE_ROLLBACK_FAILED"
        logger.info "Cannot run operation on stack #{@stack} is not in an updatable state.  Stack status: #{status}".color(:red)
        quit 1
      end
    end

    # All CloudFormation states listed here:
    # http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-describing-stacks.html
    def stack_status
      resp = cfn.describe_stacks(stack_name: @stack)
      resp.stacks[0].stack_status
    end
  end
end
