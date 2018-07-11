require "thor"

class Lono::Cfn < Lono::Command
  autoload :AwsService, 'lono/cfn/aws_service'
  autoload :Base, 'lono/cfn/base'
  autoload :CLI, 'lono/cfn/cli'
  autoload :Create, 'lono/cfn/create'
  autoload :Current, 'lono/cfn/current'
  autoload :Delete, 'lono/cfn/delete'
  autoload :Diff, 'lono/cfn/diff'
  autoload :Download, 'lono/cfn/download'
  autoload :Preview, 'lono/cfn/preview'
  autoload :Status, 'lono/cfn/status'
  autoload :Update, 'lono/cfn/update'
  autoload :Util, 'lono/cfn/util'

  class_option :verbose, type: :boolean
  class_option :noop, type: :boolean

  base_options = Proc.new do
    # common to create and update
    option :template, desc: "override convention and specify the template file to use"
    option :param, desc: "override convention and specify the param file to use"
    option :lono, type: :boolean, desc: "invoke lono to generate CloudFormation templates", default: true
    option :capabilities, type: :array, desc: "iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM"
    option :iam, type: :boolean, desc: "Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM"
    option :rollback, type: :boolean, desc: "rollback", default: true
  end
  wait_option = Proc.new do
    option :wait, type: :boolean, desc: "Wait for stack operation to complete.", default: true
  end

  desc "create STACK", "Create a CloudFormation stack using the generated template."
  base_options.call
  wait_option.call
  long_desc Lono::Help.text("cfn/create")
  def create(stack_name)
    Create.new(stack_name, options).run
  end

  desc "update STACK", "Update a CloudFormation stack using the generated template."
  long_desc Lono::Help.text("cfn/update")
  option :change_set, type: :boolean, default: true, desc: "Uses generated change set to update the stack.  If false, will perform normal update-stack."
  option :diff, type: :boolean, default: true, desc: "Show diff of the source code template changes before continuing."
  option :preview, type: :boolean, default: true, desc: "Show preview of the stack changes before continuing."
  option :sure, type: :boolean, desc: "Skips are you sure prompt"
  base_options.call
  wait_option.call
  def update(stack_name=:current)
    Update.new(stack_name, options).run
  end

  desc "delete STACK", "Delete a CloudFormation stack."
  long_desc Lono::Help.text("cfn/delete")
  option :sure, type: :boolean, desc: "Skips are you sure prompt"
  base_options.call
  wait_option.call
  def delete(stack_name=:current)
    Delete.new(stack_name, options).run
  end

  desc "preview STACK", "Preview a CloudFormation stack update.  This is similar to terraform's plan or puppet's dry-run mode."
  long_desc Lono::Help.text("cfn/preview")
  option :keep, type: :boolean, desc: "keep the changeset instead of deleting it afterwards"
  option :diff, type: :boolean, default: true, desc: "Show diff of the source code template changes also."
  base_options.call
  def preview(stack_name=:current)
    Diff.new(stack_name, options).run if options[:diff]
    Preview.new(stack_name, options).run
  end

  desc "diff STACK", "Diff newly generated template vs existing template."
  long_desc Lono::Help.text("cfn/diff")
  base_options.call
  def diff(stack_name=:current)
    Diff.new(stack_name, options).run
  end

  desc "download STACK", "Download CloudFormation template from existing stack."
  long_desc Lono::Help.text("cfn/download")
  option :name, desc: "Name you want to save the template as. Default: existing stack name."
  base_options.call
  def download(stack_name=:current)
    Download.new(stack_name, options).run
  end

  desc "current", "Current stack that you're working with."
  long_desc Lono::Help.text("cfn/current")
  option :rm, type: :boolean, desc: "Remove all current settings. Removes `.lono/current`"
  option :name, desc: "Current stack name."
  option :suffix, desc: "Current suffix for stack name."
  def current
    Current.new(options).run
  end

  desc "status", "Shows the current status for the stack."
  long_desc Lono::Help.text("cfn/status")
  def status(stack_name=:current)
    Status.new(stack_name, options).run
  end
end
