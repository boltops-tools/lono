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

  # Instance eval's the template declarations in app/stacks in this order:
  #
  #   app/stacks/base.rb
  #   app/stacks/base - all files in folder
  #   app/stacks/[Lono.env].rb
  #   app/stacks/[Lono.env] - all files in folder
  #
  # So Lono.env specific template declarations override base template declarations.
  def evaluate_templates
    evaluate_template("base")
    evaluate_folder("base")
    evaluate_template(Lono.env)
    evaluate_folder(Lono.env)
  end

  def evaluate_template(name)
    path = "#{Lono.config.stacks_path}/#{name}.rb"
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
    paths = Dir.glob("#{Lono.config.stacks_path}/#{folder}/**/*")
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
      validate(text, path)
      File.open(path, 'w') do |f|
        f.write(commented(text))
      end
    end
  end

  def validate(text, path)
    begin
      YAML.load(text)
    rescue Psych::SyntaxError => e
      puts "Invalid yaml.  Output written to #{path} for debugging".colorize(:red)
      puts "ERROR: #{e.message}".colorize(:red)
      File.open(path, 'w') {|f| f.write(text) }
      ENV['TEST'] ? raise : exit(1)
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
