class Lono::Template::DSL
  def initialize(options={})
    @options = options
    @project_root = @options[:project_root] || '.'
    @config_path = "#{@project_root}/config"
    Lono::ProjectChecker.check(@project_root)
    @templates = []
    @results = {}
    @detected_format = nil
  end

  def run(options={})
    evaluate_templates
    build_templates
    write_output
  end

  # Instance eval's all the files within each folder under
  #   config/lono/base and config/lono/[LONO_ENV]
  # Base gets base first and then the LONO_ENV configs get evaluate second.
  # This means the env specific configs override the base configs.
  def evaluate_templates
    evaluate_folder("base")
    evaluate_folder(LONO_ENV)
    @detected_format = detect_format
  end

  def evaluate_folder(folder)
    paths = Dir.glob("#{@config_path}/templates/#{folder}/**/*")
    paths.select{ |e| File.file?(e) }.each do |path|
      evaluate_template(path)
    end
  end

  def evaluate_template(path)
    begin
      instance_eval(File.read(path), path)
    rescue Exception => e
      template_evaluation_error(e)
      puts "\nFull error:"
      raise
    end
  end

  # Prints out a user friendly task_definition error message
  def template_evaluation_error(e)
    error_info = e.backtrace.first
    path, line_no, _ = error_info.split(':')
    line_no = line_no.to_i
    puts "Error evaluating #{path}:".colorize(:red)
    puts e.message
    puts "Here's the line in #{path} with the error:\n\n"

    contents = IO.read(path)
    content_lines = contents.split("\n")
    context = 5 # lines of context
    top, bottom = [line_no-context-1, 0].max, line_no+context-1
    spacing = content_lines.size.to_s.size
    content_lines[top..bottom].each_with_index do |line_content, index|
      line_number = top+index+1
      if line_number == line_no
        printf("%#{spacing}d %s\n".colorize(:red), line_number, line_content)
      else
        printf("%#{spacing}d %s\n", line_number, line_content)
      end
    end
  end

  # Detects the format of the templates.  Checks the extension of all the
  # templates files.
  # All the templates must be of the same format, either all json or all yaml.
  def detect_format
    extensions = Dir.glob("#{@project_root}/templates/**/*").map do |path|
      File.extname(path).sub(/^\./,'')
    end.reject(&:empty?).uniq
    extensions.include?('yml') ? 'yml' : 'json' # defaults to yml - falls back to json
  end

  def template(name, &block)
    @templates << {name: name, block: block}
  end

  def build_templates
    options = @options.merge(detected_format: @detected_format)
    @templates.each do |t|
      @results[t[:name]] = Lono::Template::Template.new(t[:name], t[:block], options).build
    end
  end

  def write_output
    output_path = "#{@project_root}/output"
    FileUtils.rm_rf(output_path) if @options[:clean]
    FileUtils.mkdir(output_path) unless File.exist?(output_path)
    puts "Generating CloudFormation templates:" unless @options[:quiet]
    @results.each do |name,text|
      path = "#{output_path}/#{name}".sub(/^\.\//,'') # strip leading '.'
      path += ".#{@detected_format}"
      puts "  #{path}" unless @options[:quiet]
      ensure_parent_dir(path)
      validate(text, path)
      File.open(path, 'w') do |f|
        f.write(output_format(text))
      end
    end
  end

  def validate(text, path)
    if @detected_format == "json"
      validate_json(text, path)
    else
      validate_yaml(text, path)
    end
  end

  def validate_yaml(yaml, path)
    begin
      YAML.load(yaml)
    rescue Psych::SyntaxError => e
      puts "Invalid yaml.  Output written to #{path} for debugging".colorize(:red)
      puts "ERROR: #{e.message}".colorize(:red)
      File.open(path, 'w') {|f| f.write(yaml) }
      exit 1
    end
  end

  def validate_json(json, path)
    begin
      JSON.parse(json)
    rescue JSON::ParserError => e
      puts "Invalid json.  Output written to #{path} for debugging".colorize(:red)
      puts "ERROR: #{e.message}".colorize(:red)
      File.open(path, 'w') {|f| f.write(json) }
      exit 1
    end
  end

  def output_format(text)
    @options[:pretty] ? prettify(text) : text
  end

  # Input text is either yaml or json.
  # Do not prettify yaml format because it removes the !Ref like CloudFormation notation
  def prettify(text)
    @detected_format == "json" ? JSON.pretty_generate(JSON.parse(text)) : yaml_format(text)
  end

  def yaml_format(text)
    comment =<<~EOS
      # This file was generated with lono. Do not edit directly, the changes will be lost.
      # More info: http://lono.cloud
    EOS
    "#{comment}#{remove_blank_lines(text)}"
  end

  # ERB templates leaves blank lines around, remove those lines
  def remove_blank_lines(text)
    text.split("\n").reject { |l| l.strip == '' }.join("\n") + "\n"
  end

  def ensure_parent_dir(path)
    dir = File.dirname(path)
    FileUtils.mkdir_p(dir) unless File.exist?(dir)
  end
end
