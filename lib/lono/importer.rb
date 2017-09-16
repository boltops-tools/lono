require "open-uri"
require "json"
require "yaml"

class Lono::Importer
  attr_reader :options
  def initialize(source, options)
    @source = source
    @options = options
    @format = normalize_format(@options[:format])
    @project_root = options[:project_root] || '.'
  end

  def run
    download_template
    template_definition_path = add_template_definition
    puts "Imported raw CloudFormation template and lono-fied it!"
    puts "Template definition added to #{template_definition_path}."
    puts "Template downloaded to #{dest_path}."
  end

  def download_template
    template =  open(@source).read

    result = if @format == 'yml'
                YAML.dump(YAML.load(template))
              else
                JSON.pretty_generate(JSON.load(template))
              end

    folder = File.dirname(dest_path)
    FileUtils.mkdir_p(folder) unless File.exist?(folder)
    IO.write(dest_path, result)
  end

  # Add template definition to config/templates/base/stacks.rb.
  def add_template_definition
    path = "#{@project_root}/config/templates/base/stacks.rb"
    lines = File.exist?(path) ? IO.readlines(path) : []
    new_template_definition = %Q|template "#{template_name}"|
    unless lines.detect { |l| l.include?(new_template_definition) }
      lines << ["\n", new_template_definition]
      result = lines.join('')
      IO.write(path, result)
    end
    path
  end

  def dest_path
    "#{@project_root}/templates/#{template_name}.#{@format}"
  end

  def template_name
    name = File.basename(@source, ".*")
    @options[:casing] == "camelcase" ? name.camelize : name.underscore.dasherize
  end

private
  def normalize_format(format)
    format == 'yaml' ? 'yml' : format
  end
end
