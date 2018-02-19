class Lono::Param::Generator
  def self.generate_all(options)
    puts "Generating parameter files:"

    params = param_names("base") + param_names(Lono.env)
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
  def self.param_names(folder)
    base_folder = "#{Lono.config.params_path}/#{folder}" # Example: "./params/base"
    Dir.glob("#{base_folder}/**/*.txt").map do |path|
      path.sub("#{base_folder}/", '').sub('.txt','')
    end
  end

  def initialize(name, options)
    @name = "#{Lono.env}/#{name}"
    @options = options
    @env_path = options[:path] || "#{Lono.config.params_path}/#{@name}.txt"
    @base_path = @env_path.sub("/#{Lono.env}/", "/base/")
  end

  def generate
    # useful option for lono cfn
    return if @options[:allow_no_file] && !source_exist?

    if source_exist?
      contents = process_erb
      data = convert_to_cfn_format(contents)
      json = JSON.pretty_generate(data)
      write_output(json)
      # Example: @name = stag/ecs/private
      #          pretty_name = ecs/private
      pretty_name = @name.sub("#{Lono.env}/", '')
      puts "  #{output_path}" unless @options[:mute]
    else
      puts "#{@base_path} or #{@env_path} could not be found?  Are you sure it exist?"
      exit 1
    end
    json
  end

  # useful for when calling CloudFormation via the aws-sdk gem
  def params(casing = :underscore)
    # useful option for lono cfn
    return {} if @options[:allow_no_file] && !source_exist?

    contents = process_erb
    convert_to_cfn_format(contents, casing)
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
  def process_erb
    contents = []
    contents << render_erb(@base_path)
    contents << render_erb(@env_path)
    contents.compact.join("\n")
  end

  def render_erb(path)
    if File.exist?(path)
      RenderMePretty.result(path, context: context)
    end
  end

  # Context for ERB rendering.
  # This is where we control what references get passed to the ERB rendering.
  def context
    @context ||= Lono::Template::Context.new(@options)
  end

  # Checks both base and source path for existing of the param file.
  # Example:
  #   params/base/mystack.txt - base path
  #   params/prod/mystack.txt - source path
  def source_exist?
    File.exist?(@base_path) || File.exist?(@env_path)
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
    name = @name.sub("#{Lono.env}/", "") # remove the Lono.env from the output path
    "#{Lono.config.output_path}/params/#{name}.json".sub(/\.\//,'')
  end

  def write_output(json)
    dir = File.dirname(output_path)
    FileUtils.mkdir_p(dir)
    IO.write(output_path, json)
  end
end
