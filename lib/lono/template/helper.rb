# This is included into Lono::Template::Context.
# It has access to the original thor CLI options via @options.
#
# @options gets passed into:
#
#   Lono::Template::Context.new(@options)
module Lono::Template::Helper
  # Bash code that is meant to included in user-data
  def extract_s3_scripts(options={})
    settings = Lono::Setting.new.data
    # defaults also here in case they are removed from settings
    dest = options[:dest] || settings[:dest] || "/opt"
    user = options[:user] || settings[:user] || "ec2-user"

    <<-BASH_CODE
# Download scripts from #{s3_scripts_tarball} and setup
mkdir -p #{dest}
aws s3 cp #{s3_scripts_tarball} #{dest}/
cd #{dest}
tar zxf #{dest}/scripts.tgz
chmod -R +x #{dest}/scripts
chown -R #{user}:#{user} #{dest}/scripts
BASH_CODE
  end

  def s3_scripts_tarball
    upload = Lono::Script::Upload.new
    upload.s3_dest
  end

  def template_s3_path(template_name)
    template_path = "#{template_name}.yml"

    # must have settings.s3_path for this to owrk
    settings = Lono::Setting.new
    if settings.s3_path
      # high jacking Upload for useful s3_https_url method
      upload = Lono::Template::Upload.new(@options)
      upload.s3_https_url(template_path)
    else
      message = "template_s3_path helper called but s3_path not configured in settings.yml"
      puts "ERROR: #{message}".colorize(:red)
      exit 1
    end
  end

  def template_params(param_name)
    generator_options = {
      allow_no_file: true
    }.merge(@options)
    generator = Lono::Param::Generator.new(param_name, generator_options)
    # do not generate because lono cfn calling logic already generated it we only need the values
    generator.params    # Returns Array in underscore keys format
  end

  # Adjust the partial path so that it will use app/user_data
  def user_data(path,vars={}, options={})
    options.merge!(user_data: true)
    partial(path,vars, options)
  end

  # The partial's path is a relative path.
  #
  # Example:
  # Given file in app/partials/iam/docker.yml
  #
  #   <%= partial("iam/docker", {}, indent: 10) %>
  #   <%= partial("iam/docker.yml", {}, indent: 10) %>
  #
  # If the user specifies the extension then use that instead of auto-adding
  # the detected format.
  def partial(path,vars={}, options={})
    path = options[:user_data] ?
              user_data_path_for(path) :
              partial_path_for(path)
    path = auto_add_format(path)

    instance_variables!(vars)
    result = render_path(path)

    result = indent(result, options[:indent]) if options[:indent]
    result + "\n"
  end

  # add indentation
  def indent(text, indentation_amount)
    text.split("\n").map do |line|
      " " * indentation_amount + line
    end.join("\n")
  end

  def partial_exist?(path)
    path = partial_path_for(path)
    path = auto_add_format(path)
    path && File.exist?(path)
  end

  def current_region
    region = Aws.config[:region]
    region ||= ENV['AWS_REGION']
    return region if region

    default_region = 'us-east-1' # fallback if default not found in ~/.aws/config
    if ENV['AWS_PROFILE']
      path = "#{ENV['HOME']}/.aws/config"
      if File.exist?(path)
        lines = IO.readlines(path)
        capture_default, capture_current = false, false
        lines.each do | line|
          if line.include?('[default]')
            capture_default = true # next line
            next
          end
          if capture_default && line.match(/region = /)
            # over default from above
            default_region = line.split(' = ').last.strip
            capture_default = false
          end

          md = line.match(/\[profile (.*)\]/)
          if md && md[1] == ENV['AWS_PROFILE']
            capture_current = true
            next
          end
          if capture_current && line.match(/region = /)
            region = line.split(' = ').last.strip
            capture_current = false
          end
        end
      end

      region ||= default_region
      return region if region
    end

    'us-east-1' # default
  end

private
  def render_path(path)
    RenderMePretty.result(path, context: self)
  end

  def user_data_path_for(path)
    "#{Lono.config.user_data_path}/#{path}"
  end

  def partial_path_for(path)
    "#{Lono.config.partials_path}/#{path}"
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
