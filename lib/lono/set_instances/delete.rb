class Lono::SetInstances
  class Delete < Changeable
    def initialize(options={})
      super
      @stack = options[:stack]
    end

    def run
      validate!

      sure?("Are you sure you want to delete the #{@stack} stack instances?", long_desc)

      # delete_stack_instances resp has operation_id
      # Could also use that to poll for status with the list_stack_set_operation_results
      # api. Currently, Instance::Status class not using this info. If we need will add the logic.
      retain_stacks = @options[:retain_stacks] ? @options[:retain_stacks] : false
      resp = cfn.delete_stack_instances(
        stack_set_name: @stack,
        accounts: accounts,
        regions: regions,
        retain_stacks: retain_stacks,
      )
      operation_id = resp.operation_id

      # Status tailing handled by caller
      o = @options.merge(
        filter: requested,
        start_on_outdated: false,
        operation_id: operation_id,
      )
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
  end
end