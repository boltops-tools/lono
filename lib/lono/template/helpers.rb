module Lono::Template::Helpers
  def template_s3_path(template_name)
    format = @_detected_format.sub('yaml','yml')
    template_path = "#{template_name}.#{format}"

    # must have settings.s3_path for this to owrk
    settings = Lono::Settings.new(@project_root)
    if settings.s3_path
      # high jacking Upload for useful s3_https_url method
      upload = Lono::Template::Upload.new(@_options)
      upload.s3_https_url(template_path)
    else
      message = "template_s3_path helper called but s3.path not configured in lono/settings.yml"
      puts "WARN: #{message}".colorize(:yellow)
      message
    end
  end

  def template_params(param_name)
    param_path = "params/#{LONO_ENV}/#{param_name}.txt"
    generator_options = {
      project_root: @_project_root,
      path: param_path,
      allow_no_file: true
    }.merge(@_options)
    generator = Lono::Param::Generator.new(param_name, generator_options)
    # do not generate because lono cfn calling logic already generated it we only need the values
    generator.params    # Returns Array in underscore keys format
  end

  def user_data(path, vars={})
    path = "#{@_project_root}/templates/user_data/#{path}"
    template = IO.read(path)
    variables(vars)
    result = erb_result(path, template)
    output = []
    result.split("\n").each do |line|
      output += transform(line)
    end
    json = output.to_json
    json[0] = '' # remove first char: [
    json.chop!   # remove last char:  ]
  end

  def ref(name)
    %Q|{"Ref"=>"#{name}"}|
  end

  def find_in_map(*args)
    %Q|{"Fn::FindInMap" => [ #{transform_array(args)} ]}|
  end

  def base64(value)
    %Q|{"Fn::Base64"=>"#{value}"}|
  end

  def get_att(*args)
    %Q|{"Fn::GetAtt" => [ #{transform_array(args)} ]}|
  end

  def get_azs(region="AWS::Region")
    %Q|{"Fn::GetAZs"=>"#{region}"}|
  end

  def join(delimiter, values)
    %Q|{"Fn::Join" => ["#{delimiter}", [ #{transform_array(values)} ]]}|
  end

  def select(index, list)
    %Q|{"Fn::Select" => ["#{index}", [ #{transform_array(list)} ]]}|
  end

  def partial_exist?(path)
    path = partial_path_for(path)
    path = auto_add_format(path)
    File.exist?(path)
  end

  # The partial's path is a relative path given without the extension and
  #
  # Example:
  # Given: file in templates/partial/iam/docker.yml
  # The path should be: iam/docker
  #
  # If the user specifies the extension then use that instead of auto-adding
  # the detected format.
  def partial(path,vars={}, options={})
    path = partial_path_for(path)
    path = auto_add_format(path)

    template = IO.read(path)
    variables(vars)
    result = erb_result(path, template)
    result = indent(result, options[:indent]) if options[:indent]
    result
  end

  def partial_path_for(path)
    "#{@_project_root}/templates/partial/#{path}"
  end

  def auto_add_format(path)
    extension = File.extname(path)
    path += ".#{@_detected_format}" if extension.empty?
    path
  end

  # add indentation
  def indent(result, indentation_amount)
    result.split("\n").map do |line|
      " " * indentation_amount + line
    end.join("\n")
  end

end
