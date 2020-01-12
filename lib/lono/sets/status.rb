class Lono::Sets
  class Status
    extend Memoist
    include Lono::AwsServices
    include Summarize
    include TimeSpent

    attr_reader :operation_id
    def initialize(options={})
      @options = options
      @stack, @operation_id = options[:stack], options[:operation_id]
      @shown = []
      @output = "" # for say method and specs
    end

    def wait
      status = nil
      until completed?(status)
        resp = display_one
        stack_set_operation = resp.stack_set_operation
        status = stack_set_operation.status
        # always sleep delay even if completed to provide start_instances_status_waiter some extra time to complete
        sleep 5
        if completed?(status)
          show_time_spent(stack_set_operation)
        else
          start_instances_status_waiter
        end
      end
      status == "SUCCEEDED"
    end

    def display_one
      resp = cfn.describe_stack_set_operation(
        stack_set_name: @stack,
        operation_id: operation_id,
      )
      stack_set_operation = resp.stack_set_operation
      show_stack_set_operation(stack_set_operation)
      @shown << stack_set_operation
      resp
    end

    def show
      display_one
      o = @options.merge(show_time_spent: false)
      instances_status = Lono::Sets::Instances::Status.new(o)
      instances_status.run
      summarize(operation_id)
    end

    @@instances_status_waiter_started = false
    def start_instances_status_waiter
      return if @@instances_status_waiter_started
      if stack_instances.empty?
        @@instances_status_waiter_started = true
        return
      end

      Thread.new do
        # show_time_spent because we already show it in this status class. Dont want it to show twice.
        o = @options.merge(start_on_outdated: true, show_time_spent: false)
        instances_status = Lono::Sets::Instances::Status.new(o)
        instances_status.run
      end
      @@instances_status_waiter_started = true
    end

    def show_stack_set_operation(stack_set_operation)
      already_shown = @shown.detect do |o|
        o[:status] == stack_set_operation[:status]
      end
      return if already_shown

      say "Stack Set Operation Status: #{stack_set_operation.status}"
    end

    def say(text)
      ENV["LONO_TEST"] ? @output << "#{text}\n" : puts(text)
    end

    # describe_stack_set_operation stack_set_operation.status is
    # one of RUNNING, SUCCEEDED, FAILED, STOPPING, STOPPED
    def completed?(status)
      completed_statuses = %w[SUCCEEDED FAILED STOPPED]
      completed_statuses.include?(status)
    end

    def stack_set_status
      resp = cfn.describe_stack_set_operation(
        stack_set_name: @stack,
        operation_id: operation_id,
      )
      # describe_stack_set_operation stack_set_operation.status is
      # status one of RUNNING, SUCCEEDED, FAILED, STOPPING, STOPPED
      resp.stack_set_operation.status
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

    def stack_instances
      Lono::Sets::Status::Instances.new(@options).stack_instances
    end
    memoize :stack_instances
  end
end
