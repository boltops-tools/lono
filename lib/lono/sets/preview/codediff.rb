module Lono::Sets::Preview
  class Codediff < Lono::Sets::Base
    include Lono::Cfn::Preview::DiffViewer

    def run
      unless stack_set_exists?(@stack)
        puts "WARN: Cannot create a diff for the stack set because the #{@stack} does not exists.".color(:yellow)
        return
      end

      if @options[:noop]
        puts "NOOP Generating CloudFormation source code diff..."
      else
        generate_all # from Base superclass. Generates the output lono teplates
        puts "Generating CloudFormation source code diff..."
        download_existing_cfn_template
        show_diff(existing_template_path, new_cfn_template)
      end
    end

    def download_existing_cfn_template
      resp = cfn.describe_stack_set(stack_set_name: @stack)
      IO.write(existing_template_path, resp.stack_set.template_body)
    end

    # for clarity
    def new_cfn_template
      template_path
    end

    def existing_template_path
      "/tmp/existing_stack_set.yml"
    end
  end
end
