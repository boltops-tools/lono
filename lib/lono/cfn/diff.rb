class Lono::Cfn
  class Diff < Base
    include DiffViewer
    include Lono::AwsServices

    def run
      unless stack_exists?(@stack_name)
        puts "WARN: Cannot create a diff for the stack because the #{@stack_name} does not exists.".color(:yellow)
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
        stack_name: @stack_name,
        template_stage: "Original"
      )
      resp.template_body
      IO.write(existing_template_path, resp.template_body)
    end

    # for clarity
    def new_cfn_template
      @template_path
    end

    def existing_template_path
      "/tmp/existing_cfn_template.yml"
    end
  end
end
