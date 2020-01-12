module Lono::Inspector
  class Base < Lono::AbstractBase
    extend Memoist

    def run
      generate
      templates = @template_name ? [@template_name] : all_templates
      templates.each do |template_name|
        perform(template_name)
      end
    end

    def generate
      if @options[:source]
        Lono::Cfn::Download.new(@options).run
      else
        generate_templates
      end
    end

    def generate_templates
      Lono::Template::Generator.new(@options.merge(quiet: false)).run
    end

    def all_templates
      templates_path = "#{Lono.config.output_path}/#{@blueprint}/templates"
      Dir.glob("#{templates_path}/**").map do |path|
        path.sub("#{templates_path}/", '').sub('.yml','') # template_name
      end
    end
  end
end
