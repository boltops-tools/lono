require "lono"

class Lono::Cfn::Base
  include Lono::Cfn::AwsService
  include Lono::Cfn::Util

  def initialize(stack_name, options={})
    @options = options # options must be set first because @option used in append_suffix
    stack_name = switch_current(stack_name)
    @stack_name = append_suffix(stack_name)
    Lono::ProjectChecker.check unless options[:lono] # already ran checker in lono generate

    @template_name = options[:template] || remove_suffix(@stack_name)
    @param_name = options[:param] || @template_name
    @template_path = get_source_path(@template_name, :template)
    @param_path = get_source_path(@param_name, :param)
    puts "Using template: #{@template_path}" unless @options[:mute_using]
    puts "Using parameters: #{@param_path}" unless @options[:mute_using]
  end

  def switch_current(stack_name)
    Lono::Cfn::Current.name!(stack_name)
  end

  def starting_message
    action = self.class.to_s.split('::').last
    action = action[0..-2] + 'ing' # create => creating
    puts "#{action} #{@stack_name.color(:green)} stack..."
  end

  def run
    starting_message
    params = generate_all
    begin
      save_stack(params) # defined in the sub class
    rescue Aws::CloudFormation::Errors::InsufficientCapabilitiesException => e
      capabilities = e.message.match(/\[(.*)\]/)[1]
      confirm = prompt_for_iam(capabilities)
      if confirm =~ /^y/
        @options.merge!(capabilities: [capabilities])
        puts "Re-running: #{command_with_iam(capabilities).color(:green)}"
        retry
      else
        puts "Exited"
        exit 1
      end
    end

    return unless @options[:wait]
    status.wait unless @options[:noop]
  end

  def status
    @status ||= Lono::Cfn::Status.new(@stack_name)
  end

  def prompt_for_iam(capabilities)
    puts "This stack will create IAM resources.  Please approve to run the command again with #{capabilities} capabilities."
    puts "  #{command_with_iam(capabilities)}"

    puts "Please confirm (y/n)"
    $stdin.gets
  end

  def command_with_iam(capabilities)
    "#{File.basename($0)} #{ARGV.join(' ')} --capabilities #{capabilities}"
  end

  def generate_all
    if @options[:lono]
      build_scripts
      generate_templates
      unless @options[:noop]
        upload_scripts
        upload_files
        upload_templates
      end
    end
    params = generate_params(mute: @options[:mute_params])
    check_for_errors
    params
  end

  def build_scripts
    Lono::Script::Build.new.run
  end

  def generate_templates
    Lono::Template::DSL.new.run
  end

  # only upload templates if s3_folder configured in settings
  def upload_templates
    Lono::Template::Upload.new.run if s3_folder
  end

  # only upload templates if s3_folder configured in settings
  def upload_scripts
    return unless s3_folder
    Lono::Script::Upload.new.run
  end

  def upload_files
    return unless s3_folder
    Lono::FileUploader.new.upload_all
  end

  def generate_params(options={})
    generator_options = {
      path: @param_path,
      allow_no_file: true
    }.merge(options)
    generator = Lono::Param::Generator.new(@param_name, generator_options)
    generator.generate  # Writes the json file in CamelCase keys format
    generator.params    # Returns Array in underscore keys format
  end

  def check_for_errors
    errors, warns = check_files
    unless errors.empty?
      puts "Please double check the command you ran.  There were some errors."
      puts "ERROR: #{errors.join("\n")}".color(:red)
      exit
    end
    unless warns.empty?
      puts "Please double check the command you ran.  There were some warnings."
      puts "WARN: #{warns.join("\n")}".color(:yellow)
    end
  end

  def check_files
    errors, warns = [], []
    unless File.exist?(@template_path)
      errors << "Template file missing: could not find #{@template_path}"
    end
    # Examples:
    #   @param_path = params/prod/ecs.txt
    #              => output/params/prod/ecs.json
    output_param_path = @param_path.sub(/\.txt/, '.json')
    output_param_path = "#{Lono.config.output_path}/#{output_param_path}"
    if @options[:param] && !File.exist?(output_param_path)
      warns << "Parameters file missing: could not find #{output_param_path}"
    end
    [errors, warns]
  end

  # if existing in params path then use that
  # if it doesnt assume it is a full path and check that
  # else fall back to convention, which also eventually gets checked in check_for_errors
  #
  # Type - :param or :template
  def get_source_path(path, type)
    if path.nil?
      convention_path(@stack_name, type) # default convention
    else
      # convention path based on the input from the user
      convention_path(path, type)
    end
  end

  def convention_path(name, type)
    path = case type
    when :template
      "#{Lono.config.output_path}/templates/#{name}.yml"
    when :param
      "#{Lono.config.params_path}/#{Lono.env}/#{name}.txt"
    else
      raise "hell: dont come here"
    end
    path.sub(/^\.\//, '')
  end

  # All CloudFormation states listed here:
  # http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-describing-stacks.html
  def stack_status(stack_name)
    return true if testing_update?
    return false if @options[:noop]

    resp = cfn.describe_stacks(stack_name: stack_name)
    resp.stacks[0].stack_status
  end

  def exit_unless_updatable!(status)
    return true if testing_update?
    return false if @options[:noop]

    unless status =~ /_COMPLETE$/
      puts "Cannot create a change set for the stack because the #{@stack_name} is not in an updatable state.  Stack status: #{status}".color(:red)
      quit(1)
    end
  end

  # To allow mocking in specs
  def quit(signal)
    exit signal
  end

  # Appends a short suffix at the end of a stack name.
  # Lono internally strips this same suffix for the template name.
  # Makes it convenient for the development flow.
  #
  #   lono cfn current --suffix 1
  #   lono cfn create demo => demo-1
  #   lono cfn update demo-1
  #
  # Instead of typing:
  #
  #   lono cfn create demo-1 --template demo
  #   lono cfn update demo-1 --template demo
  #
  # The suffix can be specified at the CLI but can also be saved as a
  # preference.
  #
  # A random suffix can be specified with random. Example:
  #
  #   lono cfn current --suffix random
  #   lono cfn create demo => demo-[RANDOM], example: demo-abc
  #   lono cfn update demo-abc
  #
  # It is not a default setting because it might confuse new lono users.
  def append_suffix(stack_name)
    suffix = Lono.suffix == 'random' ? random_suffix : Lono.suffix
    [stack_name, suffix].compact.join('-')
  end

  def remove_suffix(stack_name)
    return stack_name unless Lono.suffix

    if stack_name_suffix == 'random'
      stack_name.sub(/-(\w{3})$/,'') # strip the random suffix at the end
    elsif stack_name_suffix
      pattern = Regexp.new("-#{stack_name_suffix}$",'')
      stack_name.sub(pattern, '') # strip suffix
    else
      stack_name
    end
  end

  # only generate random suffix for Lono::Cfn::Create class
  def random_suffix
    return nil unless self.class.name.to_s =~ /Create/
    (0...3).map { (65 + rand(26)).chr }.join.downcase # Ex: jhx
  end

  def stack_name_suffix
    if @options[:suffix] && !@options[:suffix].nil?
      return @options[:suffix] # CLI option takes highest precedence
    end

    # otherwise use the settings preference
    settings = Lono::Setting.new
    settings.data['stack_name_suffix']
  end

  def capabilities
    return @options[:capabilities] if @options[:capabilities]
    if @options[:iam]
      ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
    end
  end

  def show_parameters(params, meth=nil)
    params = params.clone.compact
    params[:template_body] = "Hidden due to size... View at: #{@template_path}"
    to = meth || "AWS API"
    puts "Parameters passed to #{to}:"
    puts YAML.dump(params.deep_stringify_keys)
  end

  def s3_folder
    setting = Lono::Setting.new
    setting.s3_folder
  end

  # Either set the templmate_body or template_url attribute based on
  # if template was uploaded to s3.
  # Nice to reference s3 url because the max size of the template body is
  # greater if the template body is on s3. Limits:
  #
  #   template_body: 51,200 bytes
  #   template_url: 460,800 bytes
  #
  # Reference: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cloudformation-limits.html
  def set_template_body!(params)
    # if s3_folder is set this means s3 upload is enabled
    if s3_folder # s3_folder defined in cfn/base.rb
      upload = Lono::Template::Upload.new
      url = upload.s3_presigned_url(@template_path)
      params[:template_url] = url
    else
      params[:template_body] = IO.read(@template_path)
    end

    params
  end
end
