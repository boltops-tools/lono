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
    add_template_definition
    puts "Importing Raw CloudFormation template and lono-ifying it"
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
    puts "Template downloaded to #{dest_path}."
  end

  # Add template definition to config/templates/base/stacks.rb.
  def add_template_definition
    path = "#{@project_root}/config/templates/base/stacks.rb"
    lines = File.exist?(path) ? IO.readlines(path) : []
    puts lines
    new_template_definition = %Q|template "#{template_name}"|
    unless lines.detect { |l| l.include?(new_template_definition) }
      lines << ["\n", new_template_definition]
      result = lines.join('')
      IO.write(path, result)
    end
    puts "Template definition added to #{path}."
  end

  def dest_path
    "#{@project_root}/templates/#{template_name}.#{@format}"
  end

  def template_name
    File.basename(@source, ".*")
  end

private
  def normalize_format(format)
    format == 'yaml' ? 'yml' : format
  end
end
