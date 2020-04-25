module Lono
  class SetInstances < Lono::Command
    opts = Opts.new(self)

    desc "create STACK_SET", "Create CloudFormation stack set instances."
    long_desc Lono::Help.text("set_instances/create")
    opts.create
    def create(stack)
      Create.new(options.merge(stack: stack)).run
    end

    desc "update STACK_SET", "Update CloudFormation stack set instances."
    long_desc Lono::Help.text("set_instances/update")
    opts.update
    def update(stack)
      Update.new(options.merge(stack: stack)).run
    end

    desc "deploy STACK_SET", "Deploy CloudFormation stack set instances"
    long_desc Lono::Help.text("set_instances/deploy")
    opts.deploy
    def deploy(stack)
      Deploy.new(options.merge(stack: stack)).run
    end

    desc "delete STACK_SET", "Delete CloudFormation stack set instances."
    long_desc Lono::Help.text("set_instances/delete")
    opts.delete
    def delete(stack)
      Delete.new(options.merge(stack: stack)).run
    end

    desc "sync STACK_SET", "Sync CloudFormation stack set instances."
    long_desc Lono::Help.text("set_instances/sync")
    opts.sync
    def sync(stack)
      Sync.new(options.merge(stack: stack)).run
    end

    desc "list STACK_SET", "List CloudFormation stack set instances."
    long_desc Lono::Help.text("set_instances/list")
    def list(stack)
      List.new(options.merge(stack: stack)).run
    end

    desc "status STACK_SET", "Show current status of stack instances."
    long_desc Lono::Help.text("set_instances/status")
    def status(stack)
      instances_status = Status.new(options.merge(stack: stack))
      success = instances_status.run
      exit 3 unless success
    end
  end
end
