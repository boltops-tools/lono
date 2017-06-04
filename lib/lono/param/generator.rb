class Lono::Param::Generator
  def self.generate_all(options)
    puts "Generating params files"
    project_root = options[:project_root] || '.'
    Dir.glob("#{project_root}/params/**/*.txt").each do |path|
      next if File.directory?(path)
      name = path.sub(/.*params\//, '').sub('.txt', '')
      param = Lono::Param::Generator.new(name, options)
      param.generate
    end
  end

  def initialize(name, options)
    @name = name
    @options = options
    @project_root = options[:project_root] || '.'
    @source_path = options[:path] || "#{@project_root}/params/#{@name}.txt"
  end

  def generate
    # useful option for lono cfn
    return if @options[:allow_no_file] && !File.exist?(@source_path)

    if File.exist?(@source_path)
      contents = IO.read(@source_path)
      data = convert_to_cfn_format(contents)
      json = JSON.pretty_generate(data)
      write_output(json)
      puts "Params file generated for #{@name} at #{output_path}" unless @options[:mute]
    else
      puts "#{@source_path} could not be found?  Are you sure it exist?"
      exit 1
    end
  end

  # useful for when calling CloudFormation via the aws-sdk gem
  def params
    # useful option for lono cfn
    return {} if @options[:allow_no_file] && !File.exist?(@source_path)

    contents = IO.read(@source_path)
    convert_to_cfn_format(contents, :underscore)
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
    params = []
    lines.each do |line|
      key,value = line.strip.split("=").map {|x| x.strip}
      param = if value == "use_previous_value"
                {
                  ParameterKey: key,
                  UsePreviousValue: true
                }
              elsif value
                {
                  ParameterKey: key,
                  ParameterValue: value
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
    "#{@project_root}/output/params/#{@name}.json".sub(/\.\//,'')
  end

  def write_output(json)
    dir = File.dirname(output_path)
    FileUtils.mkdir_p(dir) unless File.exist?(dir)
    IO.write(output_path, json)
  end

end
