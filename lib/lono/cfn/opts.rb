class Lono::Cfn
  class Opts < Lono::Opts
    def create
      base_options
      wait_options
    end

    def update
      base_options
      update_options
      wait_options
    end

    def deploy
      update
    end

    def delete
      wait_options
    end

    def cancel
      wait_options
    end

    def preview
      base_options
      update_options
      with_cli_scope do
        option :keep, type: :boolean, desc: "keep the changeset instead of deleting it afterwards"
      end
    end

    def download
      base_options
      with_cli_scope do
        option :name, desc: "Name you want to save the template as. Default: existing stack name."
        option :source, desc: "url or path to file with template"
      end
    end

    # Lono::Cfn and Lono::Sets
    def base_options(rollback: true)
      with_cli_scope do
        if rollback
          option :rollback, type: :boolean, desc: "rollback", default: true
        end
        # common to Lono::Cfn and Lono::Sets
        option :source, desc: "url or path to file with template"
        option :blueprint, desc: "override convention and specify the template file to use"
        option :capabilities, type: :array, desc: "iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM"
        option :config, aliases: "c", desc: "override convention and specify both the param and variable file to use"
        option :iam, type: :boolean, desc: "Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM"
        option :param, aliases: "p", desc: "override convention and specify the param file to use"
        option :tags, type: :hash, desc: "Tags for the stack. IE: Name:api-web Owner:bob"
        option :template, desc: "override convention and specify the template file to use"
        option :variable, aliases: "v", desc: "override convention and specify the variable file to use"
      end
    end

    def wait_options
      with_cli_scope do
        option :wait, type: :boolean, desc: "Wait for stack operation to complete.", default: true
        option :sure, type: :boolean, desc: "Skip are you sure prompt" # moved to base but used by commands like `lono cfn delete` also. Just keep here.
      end
    end

    def update_options(change_set: true)
      with_cli_scope do
        if change_set
          option :change_set, type: :boolean, default: true, desc: "Uses generated change set to update the stack.  If false, will perform normal update-stack."
          option :changeset_preview, type: :boolean, default: true, desc: "Show ChangeSet changes preview."
        end
        # common to Lono::Cfn and Lono::Sets
        option :codediff_preview, type: :boolean, default: true, desc: "Show codediff changes preview."
        option :param_preview, type: :boolean, default: true, desc: "Show parameter diff preview."
      end
    end
  end
end
