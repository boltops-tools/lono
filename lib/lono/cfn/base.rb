require "lono"

class Lono::Cfn::Base
  include Lono::Cfn::AwsService
  include Lono::Cfn::Util

  attr_reader :randomize_stack_name
  def initialize(stack_name, options={})
    @randomize_stack_name = options[:randomize_stack_name]
    @stack_name = randomize(stack_name)
    @options = options
    Lono::ProjectChecker.check unless options[:lono] # already ran checker in lono generate

    @template_name = options[:template] || derandomize(@stack_name)
    @param_name = options[:param] || @template_name
    @template_path = get_source_path(@template_name, :template)
    @param_path = get_source_path(@param_name, :param)
    puts "Using template: #{@template_path}" unless @options[:mute_using]
    puts "Using parameters: #{@param_path}" unless @options[:mute_using]
  end

  def run
    params = generate_all
    begin
      save_stack(params) # defined in the sub class
    rescue Aws::CloudFormation::Errors::InsufficientCapabilitiesException => e
      capabilities = e.message.match(/\[(.*)\]/)[1]
      confirm = prompt_for_iam(capabilities)
      if confirm =~ /^y/
        @options.merge!(capabilities: [capabilities])
        puts "Re-running: #{command_with_iam(capabilities).colorize(:green)}"
        retry
      else
        puts "Exited"
        exit 1
      end
    end

    return unless @options[:wait]
    status.wait
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
      puts "ERROR: #{errors.join("\n")}".colorize(:red)
      exit
    end
    unless warns.empty?
      puts "Please double check the command you ran.  There were some warnings."
      puts "WARN: #{warns.join("\n")}".colorize(:yellow)
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
      puts "Cannot create a change set for the stack because the #{@stack_name} is not in an updatable state.  Stack status: #{status}".colorize(:red)
      quit(1)
    end
  end

  # To allow mocking in specs
  def quit(signal)
    exit signal
  end

  # Do nothing unless in Create class
  def randomize(stack_name)
    stack_name
  end

  # Strip the random string at end of the template name
  def derandomize(template_name)
    if randomize_stack_name?
      template_name.sub(/-(\w{3})$/,'') # strip the random part at the end
    else
      template_name
    end
  end

  def randomize_stack_name?
    if !randomize_stack_name.nil?
      return randomize_stack_name # CLI option takes highest precedence
    end

    # otherwise use the settings preference
    settings = Lono::Setting.new
    settings.data['randomize_stack_name']
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
end
