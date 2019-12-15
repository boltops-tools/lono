# The Completed and Deleted classes inherit from Base.
# They implement `tail` and should not override `show`.
#
# They guarantee at least one status line is shown.
# After which they start a thread that tails until a "terminal" status is detected. However, describe_stack_instance
# resp.stack_instance.status returns:
#
#   CURRENT, OUTDATED, INOPERABLE
#
# There is no well-defined terminal status. For example, sometimes the terminal status is `CURRENT`, when the stack
# instance updates successfully:
#
#   CURRENT -> OUTDATED -> CURRENT (terminal)
#
# But sometimes the terminal state is `OUTDATED`, when the stack instance fails to update:
#
#   CURRENT -> OUTDATED (terminal)
#
# Essentially, the `describe_stack_instance` resp does not provide enough information to determine the completion of
# the `tail` logic.
#
# Hence the Completed and Deleted classes cannot be used to control the end of the polling loop. Instead, the calling
# logic is responsible for and should control when to end the polling loop.
#
# Example in Lono::Sets::Status::Instances:
#
#   with_instances do |instance|
#     Thread.new { instance.tail(to) }
#   end.map(&:join)
#   wait_until_stack_set_operation_complete
#
# The Instances logic waits on the operation results instead because its more accurate. We know from
# `describe_stack_set_operation` when the status is actually complete. The describe_stack_set_operation
# stack_set_operation.status is one of RUNNING, SUCCEEDED, FAILED, STOPPING, STOPPED.
#
# In this case, there are threads within threads. The first thread at the Instances level starts polling status
# in parallel. The instance.tail delegates to the Completed and Deleted classes.
#
# Finally, the Completed and Deleted classes are designed to block with the first poll request. So it can show at
# least one status line. Then it starts it's own thread to poll for more statuses.  Those latter statuses are not
# guaranteed to be shown. This is the responsibility of the Instances class since it has the information required to
# determine when to finish the polling loop.
#
class Lono::Sets::Status::Instance
  class Base
    include Lono::AwsServices

    class_attribute :show_time_progress
    class_attribute :delay_factor

    def initialize(stack_instance)
      @stack_instance = stack_instance
      @shown = []
      @output = "" # for say method and specs
    end

    def show_instance(stack_instance)
      already_shown = @shown.detect do |o|
        o[:account] == stack_instance[:account] &&
        o[:region] == stack_instance[:region] &&
        o[:status] == stack_instance[:status] &&
        o[:status_reason] == stack_instance[:status_reason]
      end
      return if already_shown

      s = stack_instance
      say status_line(s.account, s.region, s.status, s.status_reason)
    end

    def show_time_progress
      self.class.show_time_progress
    end

    def status_line(account, region, status, reason=nil)
      time = Time.now.strftime("%F %I:%M:%S%p") if show_time_progress
      items = [
        time,
        "Stack Instance:",
        "account".color(:purple), account,
        "region".color(:purple), region,
        "status".color(:purple), status,
      ]
      items += ["reason".color(:purple), reason] if reason
      items.compact.join(" ")
    end

    def say(text)
      ENV["LONO_TEST"] ? @output << "#{text}\n" : puts(text)
    end

    def describe_stack_instance
      retries = 0
      begin
        cfn.describe_stack_instance(
          stack_instance_account: @stack_instance.account,
          stack_instance_region: @stack_instance.region,
          stack_set_name: @stack_instance.stack_set_id)
      rescue Aws::CloudFormation::Errors::Throttling => e
        retries += 1
        delay = 2 ** retries
        if ENV['LONO_DEBUG_THROTTLE']
          puts "#{e.class}: #{e.message}"
          puts "Backing off for #{delay}s and will retry"
        end
        sleep delay
        retry
      end
    end

    def delay
      # delay factor based on number of stack instances
      factor = self.class.delay_factor || 1
      base = 4.5
      delay = factor * base
      delay = [delay, 30].min # limit the delay to a max
      puts "Sleeping for #{delay}s..." if ENV['LONO_DEBUG_THROTTLE']
      sleep delay
    end
  end
end
