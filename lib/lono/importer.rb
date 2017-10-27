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
    unless options[:noop]
      download_template
      template_definition_path = add_template_definition
      create_params
      puts "Imported raw CloudFormation template and lono-fied it!"
      puts "Template definition added to #{template_definition_path}."
      puts "Params file created to #{params_path}."
    end
    puts "Template downloaded to #{template_path}." # like having this message at the end
  end

  def download_template
    template =  open(@source).read

    result = if @format == 'yml'
                YAML.dump(YAML.load(template))
              else
                JSON.pretty_generate(JSON.load(template))
              end

    folder = File.dirname(template_path)
    FileUtils.mkdir_p(folder) unless File.exist?(folder)
    IO.write(template_path, result)
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

  # Creates starter params/base/[stack-name].txt file
  def create_params
    template = if @format == 'yml'
                YAML.load_file(template_path)
              else
                JSON.load(IO.read(template_path))
              end

    result = []
    required_parameters.each do |name, attributes|
      result << "#{name}="
    end
    optional_parameters.each do |name, attributes|
      key = "#{name}=".ljust(20, ' ')
      result << "##{key} # optional"
    end
    content = result.join("\n") + "\n"

    folder = File.dirname(params_path)
    FileUtils.mkdir_p(folder) unless File.exist?(folder)
    IO.write(params_path, content) unless File.exist?(params_path)
  end

  def params_path
    "#{@project_root}/params/base/#{template_name}.txt"
  end


  def template_path
    "#{@project_root}/templates/#{template_name}.#{@format}"
  end

  def template_name
    return @options[:name] if @options[:name]
    # else infer name from the original source
    name = File.basename(@source, ".*")
    @options[:casing] == "camelcase" ? name.camelize : name.underscore.dasherize
  end

private
  def required_parameters
    parameters.reject { |logical_id, p| p["Default"] }
  end

  def optional_parameters
    parameters.select { |logical_id, p| p["Default"] }
  end

  def parameters
    template_data["Parameters"] || []
  end

  def template_data
    return @template_data if @template_data
    template_path = "#{@project_root}/templates/#{template_name}.#{@format}"
    @template_data = YAML.load(IO.read(template_path))
  end

  def normalize_format(format)
    format == 'yaml' ? 'yml' : format
  end
end
