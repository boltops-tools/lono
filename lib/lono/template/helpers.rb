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
    path && File.exist?(path)
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
    if options[:indent]
      # Add empty line at beginning because empty lines gets stripped during
      # processing anyway. This allows the user to call partial without having
      # to put the partial call at very beginning of the line.
      # This only should happen if user is using indent option.
      ["\n", result].join("\n")
    else
      result
    end
  end

  # add indentation
  def indent(text, indentation_amount)
    text.split("\n").map do |line|
      " " * indentation_amount + line
    end.join("\n")
  end

private
  def partial_path_for(path)
    "#{@_project_root}/templates/partial/#{path}"
  end

  def auto_add_format(path)
    # Return immediately if user provided explicit extension
    extension = File.extname(path) # current extension
    return path if !extension.empty?

    # Else let's auto detect
    paths = Dir.glob("#{path}.*")

    if paths.size == 1 # non-ambiguous match
      return paths.first
    end

    if paths.size > 1 # ambiguous match
      puts "ERROR: Multiple possible partials found:".colorize(:red)
      paths.each do |path|
        puts "  #{path}"
      end
      puts "Please specify an extension in the name to remove the ambiguity.".colorize(:green)
      exit 1
    end

    # Account for case when user wants to include a file with no extension at all
    return path if File.exist?(path) && !File.directory?(path)

    path # original path if this point is reached
  end
end
