class Lono::Param::Generator
  def self.generate_all(options)
    puts "Generating params files"
    project_root = options[:project_root] || '.'

    params = param_names(project_root, "base") + param_names(project_root, LONO_ENV)
    params.uniq.each do |name|
      param = Lono::Param::Generator.new(name, options)
      param.generate
    end
  end

  # Returns param names
  # Example:
  # Given params:
  #   params/base/a.txt params/base/b.txt params/base/c.txt
  # Returns:
  #   param_names("base") => ["a", "b", "c"]
  def self.param_names(project_root, folder)
    Dir.glob("#{project_root}/params/#{folder}/*.txt").map do |path|
      File.basename(path).sub('.txt','')
    end
  end

  def initialize(name, options)
    @_name = "#{LONO_ENV}/#{name}"
    @_options = options
    @_project_root = options[:project_root] || '.'
    @_env_path = options[:path] || "#{@_project_root}/params/#{@_name}.txt"
    @_base_path = @_env_path.sub("/#{LONO_ENV}/", "/base/")
  end

  def generate
    # useful option for lono cfn
    return if @_options[:allow_no_file] && !source_exist?

    if source_exist?
      contents = overlay_sources
      data = convert_to_cfn_format(contents)
      json = JSON.pretty_generate(data)
      write_output(json)
      puts "Params file generated for #{@_name} at #{output_path}" unless @_options[:mute]
    else
      puts "#{@_base_path} or #{@_env_path} could not be found?  Are you sure it exist?"
      exit 1
    end
    json
  end

  # Reads both the base source and env source and overlay the two
  # Example 1:
  #   params/base/mystack.txt - base path
  #   params/prod/mystack.txt - env path
  #
  #   the base/mystack.txt gets combined with the prod/mystack.txt
  #   it produces a final prod/mystack.txt
  #
  # Example 2:
  #   params/base/mystack.txt - base path
  #
  #   the base/mystack.txt is used to produced a prod/mystack.txt
  #
  # Example 3:
  #   params/prod/mystack.txt - env path
  #
  #   the prod/mystack.txt is used to produced a prod/mystack.txt
  def overlay_sources
    contents = []
    contents << process_erb(@_base_path)
    contents << process_erb(@_env_path)
    contents.compact.join("\n")
  end

  def process_erb(path)
    if File.exist?(path)
      template = IO.read(path)
      erb_result(path, template)
    end
  end

  def erb_result(path, template)
    load_variables
    begin
      ERB.new(template, nil, "-").result(binding)
    rescue Exception => e
      puts e
      puts e.backtrace if ENV['DEBUG']

      # how to know where ERB stopped? - https://www.ruby-forum.com/topic/182051
      # syntax errors have the (erb):xxx info in e.message
      # undefined variables have (erb):xxx info in e.backtrac
      error_info = e.message.split("\n").grep(/\(erb\)/)[0]
      error_info ||= e.backtrace.grep(/\(erb\)/)[0]
      raise unless error_info # unable to find the (erb):xxx: error line
      line = error_info.split(':')[1].to_i
      puts "Error evaluating ERB template on line #{line.to_s.colorize(:red)} of: #{path.sub(/^\.\//, '').colorize(:green)}"

      template_lines = template.split("\n")
      context = 5 # lines of context
      top, bottom = [line-context-1, 0].max, line+context-1
      spacing = template_lines.size.to_s.size
      template_lines[top..bottom].each_with_index do |line_content, index|
        line_number = top+index+1
        if line_number == line
          printf("%#{spacing}d %s\n".colorize(:red), line_number, line_content)
        else
          printf("%#{spacing}d %s\n", line_number, line_content)
        end
      end
      exit 1 unless ENV['TEST']
    end
  end

  # Checks both base and source path for existing of the param file.
  # Example:
  #   params/base/mystack.txt - base path
  #   params/prod/mystack.txt - source path
  def source_exist?
    File.exist?(@_base_path) || File.exist?(@_env_path)
  end

  # useful for when calling CloudFormation via the aws-sdk gem
  def params(casing = :underscore)
    # useful option for lono cfn
    return {} if @_options[:allow_no_file] && !source_exist?

    contents = overlay_sources
    convert_to_cfn_format(contents, casing)
  end

  def parse_contents(contents)
    lines = contents.split("\n")
    # remove comment at the end of the line
    lines.map! { |l| l.sub(/#.*/,'').strip }
    # filter out commented lines
    lines = lines.reject { |l| l =~ /(^|\s)#/i }
    # filter out empty lines
    lines = lines.reject { |l| l.strip.empty? }
    lines
  end

  def convert_to_cfn_format(contents, casing=:camel)
    lines = parse_contents(contents)

    # First use a Hash structure so that overlay env files will override
    # the base param file.
    data = {}
    lines.each do |line|
      key,value = line.strip.split("=").map {|x| x.strip}
      data[key] = value
    end

    # Now build up the aws json format for parameters
    params = []
    data.each do |key,value|
      param = if value == "use_previous_value"
                {
                  "ParameterKey": key,
                  "UsePreviousValue": true
                }
              elsif value
                {
                  "ParameterKey": key,
                  "ParameterValue": value
                }
              end
      if param
        param = param.to_snake_keys if casing == :underscore
        params << param
      end
    end
    params
  end

  def output_path
    "#{@_project_root}/output/params/#{@_name}.json".sub(/\.\//,'')
  end

  def write_output(json)
    dir = File.dirname(output_path)
    FileUtils.mkdir_p(dir) unless File.exist?(dir)
    IO.write(output_path, json)
  end


  def load_variables
    load_variables_folder("base")
    load_variables_folder(LONO_ENV)
  end

  # Load the variables defined in config/variables/* to make available the params/*.txt files
  #
  # Example:
  #
  #   `config/variables/base/variables.rb`:
  #      @ami = 123
  #
  #   `params/ecs/private.txt`:
  #     AmiId=<%= @ami %>
  #
  def load_variables_folder(folder)
    paths = Dir.glob("#{@_project_root}/config/variables/#{folder}/**/*")
    paths.select{ |e| File.file? e }.each do |path|
      instance_eval(IO.read(path))
    end
  end

end
