class Lono::Sets::Instances
  class Delete < Base
    include Lono::AwsServices
    include Lono::Utils::Sure

    def initialize(options={})
      @options = options
      @stack = options[:stack]
    end

    def run
      validate!

      sure?("Are you sure you want to delete the #{@stack} instances?", long_desc)

      # delete_stack_instances resp has operation_id
      # Could also use that to poll for status with the list_stack_set_operation_results
      # api. Currently, Instance::Status class not using this info. If we need will add the logic.
      resp = cfn.delete_stack_instances(
        options = {
          stack_set_name: @stack,
          accounts: accounts,
          regions: regions,
          retain_stacks: false,
        }
      )
      operation_id = resp.operation_id

      # Status tailing handled by caller
      o = @options.merge(
        filter: requested,
        start_on_outdated: false,
        operation_id: operation_id,
      )
      Lono::Sets::Status::Instance::Base.show_time_progress = true
      Lono::Sets::Status::Instance::Base.delay_factor = accounts.size * regions.size
      instances_status = Status.new(o)
      instances_status.run(to: "deleted") unless @options[:noop] # returns success: true or false
    end

    def long_desc
      total = accounts.size * regions.size
      <<~EOL
      These stack instances will be deleted:

          accounts: #{accounts.join(',')}
          regions: #{regions.join(',')}

      Number of stack instances to be deleted: #{total}
      EOL
    end

    def validate!
      invalid = (regions.blank? || accounts.blank?) && !@options[:all]
      if invalid
        puts "ERROR: You must provide --accounts and --regions or --all.".color(:red)
        exit 1
      end
    end

    def accounts
      @options[:all] ? stack_instances.map(&:account).uniq : @options[:accounts]
    end

    def regions
      @options[:all] ? stack_instances.map(&:region).uniq : @options[:regions]
    end
  end
end