class Lono::Sets::Status
  class Instances
    include Lono::AwsServices
    include Lono::Sets::TimeSpent

    def initialize(options={})
      @options = options
      @stack, @operation_id = options[:stack], options[:operation_id]
      @show_time_spent = options[:show_time_spent].nil? ? true : options[:show_time_spent]
    end

    def wait(to="completed")
      puts "Stack Instance statuses... (takes a while)"
      wait_until_outdated if @options[:start_on_outdated]

      with_instances do |instance|
        Thread.new { instance.tail(to) }
      end.map(&:join)
      wait_until_stack_set_operation_complete
    end

    def show
      if stack_instances.empty?
        # Note: no access to @blueprint here
        puts <<~EOL
          There are 0 stack instances associated with the #{@stack} stack set.  Add files
          Add accounts and regions configs use `lono sets instances sync` to add stack instances.
        EOL
        return
      end

      with_instances do |instance|
        Thread.new { instance.show }
      end.map(&:join)
      wait_until_stack_set_operation_complete
    end

    def with_instances
      stack_instances.map do |stack_instance|
        instance = Instance.new(stack_instance)
        yield(instance)
      end
    end

    def wait_until_stack_set_operation_complete
      status, stack_set_operation = nil, nil
      until completed?(status)
        resp = cfn.describe_stack_set_operation(
          stack_set_name: @stack,
          operation_id: operation_id,
        )
        stack_set_operation = resp.stack_set_operation
        status = stack_set_operation.status
        # puts "DEBUG: wait_until_stack_set_operation_complete"
        unless completed?(status)
          sleep 5
        end
      end
      if @show_time_spent # or else it double shows from `lono sets deploy`. Do want it to show for `lono sets instances sync` though
        show_time_spent(stack_set_operation)
        puts "Stack set operation completed."
      end
    end

    # describe_stack_set_operation stack_set_operation.status is
    # one of RUNNING, SUCCEEDED, FAILED, STOPPING, STOPPED
    def completed?(status)
      completed_statuses = %w[SUCCEEDED FAILED STOPPED]
      completed_statuses.include?(status)
    end

    # If we dont wait until OUTDATED, during a `lono sets deploy` it'll immediately think that the instance statuses are done
    def wait_until_outdated
      outdated = false
      until outdated
        outdated = stack_instances.detect { |stack_instance| stack_instance.status == "OUTDATED" }
        sleep 5
      end
    end

    def instances
      stack_instances.map { |stack_instance| Instance.new(stack_instance) }
    end

    def stack_instances
      resp = cfn.list_stack_instances(stack_set_name: @stack)
      summaries = resp.summaries
      # filter is really only used internally. So it's fine to keep it as complex data structure since that's what we
      # build it up as in Lono::Sets::Instances::Deploy
      filter = @options[:filter] # [["112233445566", "us-west-1"],["112233445566", "us-west-2"]]
      return summaries unless filter

      summaries.reject do |s|
        intersect = [[s.account, s.region]] & filter
        intersect.empty?
      end
    end

    def operation_id
      @operation_id ||= latest_operation_id
    end

    def latest_operation_id
      resp = cfn.list_stack_set_operations(
        stack_set_name: @stack,
        max_results: 1,
      )
      resp.summaries.first.operation_id
    end
  end
end
