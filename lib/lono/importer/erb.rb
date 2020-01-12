class Lono::Importer
  class Erb < Base
    def run
      puts "=> Imported CloudFormation template.".color(:green)
      template_path = "#{Lono.config.templates_path}/#{@template}.yml"
      download_template(@source, template_path)
      puts "Template created: #{pretty_path(template_path)}"

      create_dot_lono("erb")
      template_definition_path = add_template_definition
      puts "Template definition added: #{pretty_path(template_definition_path)}"

      create_params(template_path)
      summarize
    end

    # Add template definition to app/definitions/base.rb.
    def add_template_definition
      path = "#{Lono.config.definitions_path}/base.rb"
      lines = File.exist?(path) ? IO.readlines(path) : []
      new_template_definition = %Q|template "#{@template}"|
      unless lines.detect { |l| l.include?(new_template_definition) }
        lines << ["\n", new_template_definition]
        result = lines.join('')
        FileUtils.mkdir_p(File.dirname(path))
        IO.write(path, result)
      end
      path
    end
  end
end