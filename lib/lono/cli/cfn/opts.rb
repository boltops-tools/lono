class Lono::CLI::Cfn
  class Opts < Lono::CLI::Opts
    def create
      base_options
      wait_options
    end

    def update
      base_options
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
          option :rollback, type: :boolean, desc: "rollback" # default: nil means CloudFormation default which is true
        end
        # common to Lono::Cfn and Lono::Sets
        option :capabilities, type: :array, desc: "iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM"
        option :iam, type: :boolean, desc: "Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM"
      end
    end

    def wait_options
      with_cli_scope do
        option :wait, type: :boolean, desc: "Wait for stack operation to complete.", default: true
        option :yes, aliases: :y, type: :boolean, desc: "Skip are you sure prompt" # moved to base but used by commands like `lono down` also. Just keep here.
      end
    end
  end
end
