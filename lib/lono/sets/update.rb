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
          Add `configs/#{@blueprint}/accounts` and `configs/#{@blueprint}/regions` settings
          and use `lono sets instances sync` to add stack instances.
        EOL
      else
        sure?("Are you sure you want to update the #{@stack} stack set?", long_desc)
      end

      resp = cfn.update_stack_set(options)
      operation_id = resp[:operation_id]
      puts message unless @options[:mute]

      return true if @options[:noop] || !@options[:wait]

      Lono::Sets::Status::Instance::Base.show_time_progress = true
      Lono::Sets::Status::Instance::Base.delay_factor = stack_instances.size
      status = Status.new(@options.merge(operation_id: operation_id))
      success = status.wait
      summarize(operation_id)
      exit 1 unless success
      success
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
