module Lono::Inspector
  class Base < Lono::CLI::Base
    extend Memoist

    def run
      build
      templates = @template_name ? [@template_name] : all_templates
      templates.each do |template_name|
        perform(template_name)
      end
    end

    def build
      if @options[:source]
        Lono::Cfn::Download.new(@options).run
      else
        build_templates
      end
    end

    def build_templates
      Lono::Builder::Template.new(@options.merge(quiet: false)).run
    end

    def all_templates
      templates_path = "#{Lono.root}/output/#{@blueprint.name}/templates"
      Dir.glob("#{templates_path}/**").map do |path|
        path.sub("#{templates_path}/", '').sub('.yml','') # template_name
      end
    end
  end
end
