module Lono::Cfn::Preview
  class Codediff < Lono::Cfn::Base
    include DiffViewer
    include Lono::AwsServices

    def run
      puts "Code Diff Preview:".color(:green)

      unless stack_exists?(@stack)
        puts "WARN: Cannot create a diff for the stack because the #{@stack} does not exists.".color(:yellow)
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
      resp = cfn.get_template(
        stack_name: @stack,
        template_stage: "Original"
      )
      IO.write(existing_template_path, resp.template_body)
    end

    # for clarity
    def new_cfn_template
      template_path
    end

    def existing_template_path
      "/tmp/existing_stack.yml"
    end
  end
end
