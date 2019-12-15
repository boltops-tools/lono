class Lono::Sets::Instances
  class Sync < Base
    include Lono::Sets::Summarize
    include Lono::Utils::Sure

    def initialize(options={})
      super # need conventions so config lookup will work
      @regions, @accounts = [], []
    end

    def run
      unless stack_set_exists?(@stack)
        puts "ERROR: Cannot update a stack set because #{@stack} does not exists.".color(:red)
        return
      end
      exit_unless_updatable!

      validate!

      existing = stack_instances.map do |summary|
        [summary.account, summary.region]
      end

      creates = requested - existing
      deletes = existing - requested

      if creates.empty? and deletes.empty?
        puts <<~EOL
          Nothing to be synced. IE: No stack instances need to be added or removed.  If you want to update the
          stack set and update all stack instances instead, use the `lono sets deploy` command.
        EOL
        return
      end
      sure?("Are you sure you want to sync stack instances?", long_desc(creates: creates, deletes: deletes))

      # Note: Not calling update_stack_instances because after deleting stacks it instances in in a weird state
      # where an update_stack_instances fails. Can reproduce this by deleting stacks and then trying an update_stack_instances
      # with the AWS CLI. In theory, we never really should have to call update_stack_instances anyway because
      # updating the stack set at the parent level kicks off an update_stack_instances automatically.
      operation_id = execute(:create_stack_instances, creates)
      summarize(operation_id) if operation_id
      if @options[:delete]
        operation_id = execute(:delete_stack_instances, deletes)
        summarize(operation_id) if operation_id
      end
    end

  private

    # data:
    #    {creates: creates, deletes: deletes}
    # where creates and deletes are instances_data structures:
    #    [["112233445566", "us-west-1"], ["112233445566", "us-west-1"]]
    def long_desc(data={})
      desc = "lono will run:\n"
      verbs = [:creates, :deletes]
      verbs.each do |verb|
        accounts = accounts_list(data[verb])
        regions = regions_list(data[verb])
        unless data[verb].empty?
          info = {
            accounts: accounts.join(','),
            regions: regions.join(','),
          }
          change_total = accounts.size * regions.size
          singular_verb = verb.to_s.singularize
          past_verb = verb.to_s.sub(/s$/,'d')
          message = <<~EOL
            #{singular_verb}_stack_instances for:
              accounts: #{info[:accounts]}
              regions: #{info[:regions]}

            Number of stack instances to be #{past_verb}: #{change_total}
          EOL
          desc << message
        end
      end
      desc
    end

    # meth:
    #    create_stack_set
    #    update_stack_set
    #    delete_stack_set
    #
    # instances_data:
    #   [["112233445566", "us-west-1"], ["112233445566", "us-west-1"]]
    #
    def execute(meth, instances_data)
      accounts = accounts_list(instances_data)
      regions = regions_list(instances_data)
      if accounts.empty? or regions.empty?
        # puts "Cannot have one empty. accounts: #{accounts.size} regions: #{regions.size}. No executing #{meth}." # uncomment to debug
        return # no  operation_id
      end

      options = {
        stack_set_name: @stack,
        accounts: accounts,
        regions: regions,
      }
      options[:retain_stacks] = false if meth == :delete_stack_instances
      puts <<~EOL
        => Running #{meth} on:
          accounts: #{accounts.join(',')}
          regions: #{regions.join(',')}
      EOL
      resp = cfn.send(meth, options) # resp has resp[:operation_id]
      operation_id = resp.operation_id

      # Status tailing
      o = @options.merge(
        filter: instances_data,
        operation_id: operation_id,
        start_on_outdated: meth != :delete_stack_instances,
      )
      Lono::Sets::Status::Instance::Base.show_time_progress = true
      Lono::Sets::Status::Instance::Base.delay_factor = accounts.size * regions.size
      instances_status = Status.new(o)
      final_status = meth == :delete_stack_instances ? "deleted" : "completed"
      instances_status.run(to: final_status) unless @options[:noop] # returns success: true or false
      operation_id
    end

    def accounts_list(instances_data)
      instances_data.map { |a| a[0] }.sort.uniq
    end

    def regions_list(instances_data)
      instances_data.map { |a| a[1] }.sort.uniq
    end

    # Override accounts and regions
    def accounts
      @options[:accounts] || lookup(:accounts)
    end

    def regions
      @options[:regions] || lookup(:regions)
    end

    def lookup(config_type)
      config_type = config_type.to_s
      base_path = lookup_config_location(config_type, "base")
      env_path = lookup_config_location(config_type, Lono.env)
      items = load_config(base_path)
      items += load_config(env_path)
      items = items.sort.uniq
      if config_type == :accounts
        @accounts = items
      else
        @regions = items
      end
    end

    def load_config(path)
      return [] unless path

      items = []
      lines = IO.readlines(path)
      lines.map do |l|
        l = l.strip
        l = l.sub(/ #.*/, '') # trailing comment
        items << l unless l.empty? || l.match(/^\s*#/) # dont include empty linnks or commented lines
      end
      items
    end

    def lookup_config_location(config_type, env)
      location = Lono::ConfigLocation.new(config_type, @options, env)
      env == "base" ? location.lookup_base : location.lookup
    end

    def validate!
      invalid = regions.blank? || accounts.blank?
      if invalid
        puts "ERROR: You must provide accounts and regions.".color(:red)
        exit 1
      end
    end
  end
end
