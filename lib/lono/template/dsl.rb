class Lono::Template::DSL
  def initialize(options={})
    @options = options
    Lono::ProjectChecker.check
    Lono::ProjectChecker.empty_templates
    @templates = []
    @results = {}
  end

  def run(options={})
    evaluate_templates
    build_templates
    write_output
  end

  # Instance eval's the template declarations in app/definitions in this order:
  #
  #   app/definitions/base.rb
  #   app/definitions/base - all files in folder
  #   app/definitions/[Lono.env].rb
  #   app/definitions/[Lono.env] - all files in folder
  #
  # So Lono.env specific template declarations override base template declarations.
  def evaluate_templates
    evaluate_template("base")
    evaluate_folder("base")
    evaluate_template(Lono.env)
    evaluate_folder(Lono.env)
  end

  def evaluate_template(name)
    path = "#{Lono.config.definitions_path}/#{name}.rb"
    evaluate_template_path(path)
  end

  def evaluate_template_path(path)
    return unless File.exist?(path)

    begin
      instance_eval(File.read(path), path)
    rescue Exception => e
      template_evaluation_error(e)
      puts "\nFull error:"
      raise
    end
  end

  def evaluate_folder(folder)
    paths = Dir.glob("#{Lono.config.definitions_path}/#{folder}/**/*")
    paths.select{ |e| File.file?(e) }.each do |path|
      evaluate_template_path(path)
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

  def template(name, &block)
    @templates << {name: name, block: block}
  end

  def build_templates
    @templates.each do |t|
      @results[t[:name]] = Lono::Template::Template.new(t[:name], t[:block], @options).build
    end
  end

  def write_output
    output_path = "#{Lono.config.output_path}/templates"
    FileUtils.rm_rf(output_path) if @options[:clean]
    FileUtils.mkdir_p(output_path)
    puts "Generating CloudFormation templates:" unless @options[:quiet]
    @results.each do |name,text|
      path = "#{output_path}/#{name}".sub(/^\.\//,'') # strip leading '.'
      path += ".yml"
      puts "  #{path}" unless @options[:quiet]
      ensure_parent_dir(path)
      text = commented(text)
      IO.write(path, text) # write file first so validate method is simpler
      validate(path)
    end
  end

  def validate(path)
    text = IO.read(path)
    begin
      YAML.load(text)
    rescue Psych::SyntaxError => e
      handle_yaml_syntax_error(e, path)
    end
  end

  def handle_yaml_syntax_error(e, path)
    io = StringIO.new
    io.puts "Invalid yaml.  Output written to debugging: #{path}".colorize(:red)
    io.puts "ERROR: #{e.message}".colorize(:red)

    # Grab line info.  Example error:
    #   ERROR: (<unknown>): could not find expected ':' while scanning a simple key at line 2 column 1
    md = e.message.match(/at line (\d+) column (\d+)/)
    line = md[1].to_i

    lines = IO.read(path).split("\n")
    context = 5 # lines of context
    top, bottom = [line-context-1, 0].max, line+context-1
    spacing = lines.size.to_s.size
    lines[top..bottom].each_with_index do |line_content, index|
      line_number = top+index+1
      if line_number == line
        io.printf("%#{spacing}d %s\n".colorize(:red), line_number, line_content)
      else
        io.printf("%#{spacing}d %s\n", line_number, line_content)
      end
    end

    if ENV['TEST']
      io.string
    else
      puts io.string
      exit 1
    end
  end

  def commented(text)
    comment =<<~EOS
      # This file was generated with lono. Do not edit directly, the changes will be lost.
      # More info: http://lono.cloud
    EOS
    "#{comment}#{text}"
  end

  def ensure_parent_dir(path)
    dir = File.dirname(path)
    FileUtils.mkdir_p(dir) unless File.exist?(dir)
  end
end
