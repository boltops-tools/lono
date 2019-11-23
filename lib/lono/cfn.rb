module Lono
  class Cfn < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    base_options = Proc.new do
      # common to create and update
      option :blueprint, desc: "override convention and specify the template file to use"
      option :template, desc: "override convention and specify the template file to use"
      option :param, desc: "override convention and specify the param file to use"
      option :lono, type: :boolean, desc: "invoke lono to generate CloudFormation templates", default: true
      option :capabilities, type: :array, desc: "iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM"
      option :iam, type: :boolean, desc: "Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM"
      option :rollback, type: :boolean, desc: "rollback", default: true
      option :tags, type: :hash, desc: "Tags for the stack. IE: name:api-web owner:bob"
    end
    wait_option = Proc.new do
      option :wait, type: :boolean, desc: "Wait for stack operation to complete.", default: true
    end
    suffix_option = Proc.new do
      option :suffix, desc: "Suffix for stack name."
    end
    update_options = Proc.new do
      option :change_set, type: :boolean, default: true, desc: "Uses generated change set to update the stack.  If false, will perform normal update-stack."
      option :codediff_preview, type: :boolean, default: true, desc: "Show codediff changes preview."
      option :changeset_preview, type: :boolean, default: true, desc: "Show ChangeSet changes preview."
      option :param_preview, type: :boolean, default: true, desc: "Show parameter diff preview."
      option :sure, type: :boolean, desc: "Skips are you sure prompt"
    end

    desc "create STACK", "Create a CloudFormation stack using the generated template."
    base_options.call
    suffix_option.call
    wait_option.call
    long_desc Lono::Help.text("cfn/create")
    def create(stack_name)
      Create.new(stack_name, options).run
    end

    desc "update STACK", "Update a CloudFormation stack using the generated template."
    long_desc Lono::Help.text("cfn/update")
    base_options.call
    update_options.call
    wait_option.call
    def update(stack_name=:current)
      Update.new(stack_name, options).run
    end

    desc "deploy STACK", "Create or update a CloudFormation stack using the generated template."
    long_desc Lono::Help.text("cfn/deploy")
    base_options.call
    suffix_option.call
    update_options.call
    wait_option.call
    def deploy(stack_name=:current)
      Deploy.new(stack_name, options).run
    end

    desc "delete STACK", "Delete a CloudFormation stack."
    long_desc Lono::Help.text("cfn/delete")
    option :sure, type: :boolean, desc: "Skips are you sure prompt"
    base_options.call
    wait_option.call
    def delete(stack_name=:current)
      Delete.new(stack_name, options).run
    end

    desc "cancel STACK", "Cancel a CloudFormation stack."
    long_desc Lono::Help.text("cfn/cancel")
    option :sure, type: :boolean, desc: "Skips are you sure prompt"
    wait_option.call
    def cancel(stack_name=:current)
      Cancel.new(stack_name, options).run
    end

    desc "preview STACK", "Preview a CloudFormation stack update.  This is similar to terraform's plan or puppet's dry-run mode."
    long_desc Lono::Help.text("cfn/preview")
    option :keep, type: :boolean, desc: "keep the changeset instead of deleting it afterwards"
    option :param_preview, type: :boolean, default: true, desc: "Show parameter diff preview."
    option :codediff_preview, type: :boolean, default: true, desc: "Show codediff changes preview."
    option :changeset_preview, type: :boolean, default: true, desc: "Show ChangeSet changes preview."
    base_options.call
    suffix_option.call
    def preview(stack_name=:current)
      ParamPreview.new(stack_name, options).run if options[:param_preview]
      CodediffPreview.new(stack_name, options).run if options[:codediff_preview]
      ChangesetPreview.new(stack_name, options).run if options[:changeset_preview]
    end

    desc "download STACK", "Download CloudFormation template from existing stack."
    long_desc Lono::Help.text("cfn/download")
    option :name, desc: "Name you want to save the template as. Default: existing stack name."
    base_options.call
    suffix_option.call
    def download(stack_name=:current)
      Download.new(stack_name, options).run
    end

    desc "current", "Current stack that you're working with."
    long_desc Lono::Help.text("cfn/current")
    option :rm, type: :boolean, desc: "Remove all current settings. Removes `.lono/current`"
    option :name, desc: "Current stack name."
    suffix_option.call
    def current
      Current.new(options).run
    end

    desc "status", "Shows the current status for the stack."
    long_desc Lono::Help.text("cfn/status")
    suffix_option.call
    def status(stack_name=:current)
      status = Lono::Cfn::Status.new(stack_name, options)
      success = status.run
      exit 3 unless success
    end
  end
end