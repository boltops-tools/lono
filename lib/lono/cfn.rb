require "thor"

class Lono::Cfn < Lono::Command
  autoload :Help, 'lono/cfn/help'
  autoload :AwsServices, 'lono/cfn/aws_services'
  autoload :Util, 'lono/cfn/util'
  autoload :CLI, 'lono/cfn/cli'
  autoload :Base, 'lono/cfn/base'
  autoload :Create, 'lono/cfn/create'
  autoload :Update, 'lono/cfn/update'
  autoload :Delete, 'lono/cfn/delete'
  autoload :Preview, 'lono/cfn/preview'
  autoload :Diff, 'lono/cfn/diff'

  class_option :verbose, type: :boolean
  class_option :noop, type: :boolean
  class_option :project_root, desc: "Project folder.  Defaults to current directory", default: "."
  class_option :region, desc: "AWS region"

  # common to create and update
  class_option :template, desc: "override convention and specify the template file to use"
  class_option :param, desc: "override convention and specify the param file to use"
  class_option :lono, type: :boolean, desc: "invoke lono to generate CloudFormation templates", default: true

  desc "create STACK", "create a CloudFormation stack"
  long_desc Help.create
  def create(name)
    Create.new(name, options).run
  end

  desc "update STACK", "update a CloudFormation stack"
  long_desc Help.update
  option :change_set, type: :boolean, default: true, desc: "Uses generated change set to update the stack.  If false, will perform normal update-stack."
  option :diff, type: :boolean, default: true, desc: "Show diff of the source code template changes before continuing."
  option :preview, type: :boolean, default: true, desc: "Show preview of the stack changes before continuing."
  option :sure, type: :boolean, desc: "Skips are you sure prompt"
  def update(name)
    Update.new(name, options).run
  end

  desc "delete STACK", "delete a CloudFormation stack"
  long_desc Help.delete
  option :sure, type: :boolean, desc: "Skips are you sure prompt"
  def delete(name)
    Delete.new(name, options).run
  end

  desc "preview STACK", "preview a CloudFormation stack update"
  long_desc Help.preview
  option :keep, type: :boolean, desc: "keep the changeset instead of deleting it afterwards"
  option :diff, type: :boolean, default: true, desc: "Show diff of the source code template changes also."
  def preview(name)
    Diff.new(name, options).run if options[:diff]
    Preview.new(name, options).run
  end

  desc "diff STACK", "diff of newly generated template vs existing template in AWS"
  long_desc Help.diff
  def diff(name)
    Diff.new(name, options).run
  end
end
