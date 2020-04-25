class Lono::Sets
  class Update < Base
    include Summarize

    def save
      message = "Updating #{@stack} stack set"
      if @options[:noop]
        puts "NOOP #{message}"
        return
      end

      unless stack_set_exists?(@stack)
        puts "ERROR: Cannot update a stack set because #{@stack} does not exists.".color(:red)
        return
      end
      exit_unless_updatable!

      param_preview.run if @options[:param_preview]
      codediff_preview.run if @options[:codediff_preview]
      # changeset preview not supported for stack sets

      options = build_options
      show_options(options, "cfn.update_stack_set")

      if stack_instances.empty?
        puts <<~EOL
          NOTE: There are 0 stack instances associated with the #{@stack} stack set.
          Will update the stack set template but there no instances to be updated.

          Use `lono set_instances deploy` to add stack instances. Example:

              lono set_instances deploy #{@stack} --accounts 111 --regions us-west-2 us-east-2

        EOL
      else
        sure?("Are you sure you want to update the #{@stack} stack set?", long_desc)
      end

      resp = cfn.update_stack_set(options)

      Lono::Sets::Waiter.new(@options).run(resp[:operation_id])
    end

    def stack_instances
      Lono::Sets::Status::Instances.new(@options).stack_instances
    end
    memoize :stack_instances

    def long_desc
      info = stack_instances.inject({}) do |result, instance|
        result[instance.account] ||= []
        result[instance.account] << instance.region
        result
      end
      message = "Will deploy to:\n"
      info.each do |account, regions|
        message << "  account: #{account}\n"
        message << "  regions: #{regions.join(",")}\n"
      end
      message << "\nNumber of stack instances to be updated: #{stack_instances.size}"
      message
    end

    def codediff_preview
      Lono::Sets::Preview::Codediff.new(@options.merge(mute_params: true, mute_using: true))
    end
    memoize :codediff_preview

    def param_preview
      Lono::Sets::Preview::Param.new(@options)
    end
    memoize :param_preview
  end
end
