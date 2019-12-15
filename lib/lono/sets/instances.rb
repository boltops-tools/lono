class Lono::Sets
  class Instances < Lono::Command
    opts = Opts.new(self)

    desc "delete STACK_SET", "Delete CloudFormation stack set instances."
    long_desc Lono::Help.text("sets/instances/delete")
    opts.delete
    def delete(stack)
      Delete.new(options.merge(stack: stack)).run
    end

    desc "sync STACK_SET", "Sync CloudFormation stack set instances."
    long_desc Lono::Help.text("sets/instances/sync")
    opts.sync
    def sync(stack)
      Sync.new(options.merge(stack: stack)).run
    end

    desc "list STACK_SET", "List CloudFormation stack set instances."
    long_desc Lono::Help.text("sets/instances/list")
    def list(stack)
      List.new(options.merge(stack: stack)).run
    end

    desc "status STACK_SET", "Show current status of stack instances."
    long_desc Lono::Help.text("sets/instances/status")
    def status(stack)
      instances_status = Status.new(options.merge(stack: stack))
      success = instances_status.run
      exit 3 unless success
    end
  end
end
