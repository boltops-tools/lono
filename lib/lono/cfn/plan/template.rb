class Lono::Cfn::Plan
  class Template < Base
    def run
      return unless Lono.config.plan.template
      @build.all
      logger.info "Template Changes:".color(:green)
      download_existing_cfn_template
      diff = Diff::File.new(mode: Lono.config.plan.template)
      diff.show(existing_template_path, new_cfn_template)
      logger.info "" # newline
    end

    def download_existing_cfn_template
      resp = cfn.get_template(stack_name: @stack, template_stage: "Original")
      FileUtils.mkdir_p(File.dirname(existing_template_path))
      IO.write(existing_template_path, resp.template_body)
    end

    # for clarity
    def new_cfn_template
      @blueprint.output_path
    end

    def existing_template_path
      "/tmp/lono/diff/template/existing.yml"
    end
  end
end
