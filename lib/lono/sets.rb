module Lono
  class Sets < Command
    opts = Opts.new(self)

    desc "deploy STACK_SET", "Deploy CloudFormation stack set."
    long_desc Help.text("sets/deploy")
    opts.deploy
    def deploy(stack)
      Deploy.new(options.merge(stack: stack)).run
    end

    desc "status STACK_SET", "Show current status of stack set."
    long_desc Help.text("sets/status")
    def status(stack)
      status = Status.new(@options.merge(stack: stack, delay_for_threads: false))
      success = status.show
      exit 3 unless success
    end

    desc "delete STACK_SET", "Delete CloudFormation stack set."
    long_desc Lono::Help.text("sets/delete")
    option :sure, type: :boolean, desc: "Skips are you sure prompt"
    def delete(stack)
      Delete.new(options.merge(stack: stack)).run
    end

    desc "list", "List CloudFormation stack sets."
    long_desc Lono::Help.text("sets/list")
    option :status, default: "active", desc: "active, all or deleted"
    def list
      List.new(options).run
    end

    desc "instances SUBCOMMAND", "instances subcommands"
    long_desc Help.text("sets/instances")
    subcommand "instances", Instances
  end
end
