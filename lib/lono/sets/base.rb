class Lono::Sets
  class Base < Lono::Cfn::Base
    def run
      generate_all
      save
    end

    def exit_unless_updatable!
      return true if ENV['LONO_ENV']
      return false if @options[:noop]

      status = Status.new(@options) # using status for completed?
      return if status.stack_instances.empty?
      completed = status.completed?(status.stack_set_status)
      unless completed
        puts "Cannot update stack set because #{@stack} is not in an updatable state.  Stack set status: #{status.stack_set_status}".color(:red)
        quit(1)
      end
    end

    def build_options
      parameters = generate_all
      options = {
        stack_set_name: @stack,
        parameters: parameters,
        capabilities: capabilities, # ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
      }
      options[:tags] = tags unless tags.empty?
      options[:operation_preferences] = operation_preferences unless operation_preferences.empty?
      options.reject! {|k, v| v.nil? }
      set_template_url!(options)
      options
    end

    def operation_preferences
      o = {}
      o[:failure_tolerance_count] = @options[:failure_tolerance_count]
      o[:failure_tolerance_percentage] = @options[:failure_tolerance_percentage]
      o[:max_concurrent_count] = @options[:max_concurrent_count]
      o[:max_concurrent_percentage] = @options[:max_concurrent_percentage]
      o.reject! {|k, v| v.nil? }
      o
    end
  end
end
