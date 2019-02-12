require "lono"

class Lono::Cfn
  class Base
    extend Memoist
    include AwsService
    include Lono::Blueprint::Root
    include Lono::Conventions
    include Suffix
    include Util

    def initialize(stack_name, options={})
      @options = options # options must be set first because @option used in append_suffix

      stack_name = switch_current(stack_name)
      @stack_name = append_suffix(stack_name)
      Lono::ProjectChecker.check

      @blueprint = options[:blueprint] || remove_suffix(@stack_name)
      @template, @param = template_param_convention(options)

      # Add template and param to options because used later for Lono::Param::Generator
      @options[:blueprint], @options[:template], @options[:param] = @blueprint, @template, @param

      set_blueprint_root(@blueprint)

      @template_path = "#{Lono.config.output_path}/#{@blueprint}/templates/#{@template}.yml"
    end

    def switch_current(stack_name)
      Current.name!(stack_name)
    end

    def starting_message
      action = self.class.to_s.split('::').last
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
      rescue Aws::CloudFormation::Errors::ValidationError => e
        puts "ERROR: #{e}".color(:red)
        puts e.message
        exit 1
      end

      return unless @options[:wait]
      status.wait unless @options[:noop]
    end

    def delete_rollback_stack
      rollback = Rollback.new(@stack_name)
      rollback.delete_stack
    end

    def status
      @status ||= Status.new(@stack_name)
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

    # Use class variable to cache this only runs once across all classes. base.rb, diff.rb, preview.rb
    @@generate_all = nil
    def generate_all
      return @@generate_all if @@generate_all

      if @options[:lono]
        build_scripts
        generate_templates
        unless @options[:noop]
          upload_scripts
          upload_files
          upload_templates
        end
      end

      # Pass down all options to generate_params because it eventually uses template
      param_generator.generate  # Writes the json file in CamelCase keys format
      @@generate_all = param_generator.params    # Returns Array in underscore keys format

      # At this point we have the info about params path used so we can display it.
      # We display other useful info here too so it's together logically.
      unless @options[:mute_using]
        puts "Using template: #{pretty_path(@template_path)}"
        param_generator.puts_param_message(:base)
        param_generator.puts_param_message(:env)
      end

      check_for_errors
      @@generate_all
    end

    def param_generator
      generator_options = {
        regenerate: false,
        allow_not_exists: true
      }.merge(@options)
      Lono::Param::Generator.new(@blueprint, generator_options)
    end
    memoize :param_generator

    def build_scripts
      Lono::Script::Build.new(@blueprint, @options).run
    end

    def generate_templates
      Lono::Template::Generator.new(@blueprint, @options).run
    end

    # only upload templates if s3_folder configured in settings
    def upload_templates
      Lono::Template::Upload.new(@blueprint).run if s3_folder
    end

    # only upload templates if s3_folder configured in settings
    def upload_scripts
      return unless s3_folder
      Lono::Script::Upload.new(@blueprint).run
    end

    def upload_files
      return unless s3_folder
      Lono::FileUploader.new(@blueprint).upload_all
    end

    # Maps to CloudFormation format.  Example:
    #
    #   {"a"=>"1", "b"=>"2"}
    # To
    #   [{key: "a", value: "1"}, {key: "b", value: "2"}]
    #
    def tags
      tags = @options[:tags] || []
      tags = tags.map do |k,v|
        { key: k, value: v }
      end

      update_operation = %w[Preview Update].include?(self.class.to_s)
      if tags.empty? && update_operation
        resp = cfn.describe_stacks(stack_name: @stack_name)
        tags = resp.stacks.first.tags
        tags = tags.map(&:to_h)
      end

      tags
    end

    def check_for_errors
      errors = check_files
      unless errors.empty?
        puts "Please double check the command you ran.  There were some errors."
        puts "ERROR: #{errors.join("\n")}".color(:red)
        exit
      end
    end

    def check_files
      errors = []
      unless File.exist?(@template_path)
        errors << "Template file missing: could not find #{@template_path}"
      end
      errors
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

    def capabilities
      return @options[:capabilities] if @options[:capabilities]
      if @options[:iam]
        ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
      end
    end

    def show_parameters(params, meth=nil)
      params = params.clone.compact
      params[:template_body] = "Hidden due to size... View at: #{pretty_path(@template_path)}"
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
        upload = Lono::Template::Upload.new(@blueprint)
        url_path = @template_path.sub("#{Lono.root}/",'')
        url = upload.s3_presigned_url(url_path)
        params[:template_url] = url
      else
        params[:template_body] = IO.read(@template_path)
      end

      params
    end

    def pretty_path(path)
      path.sub("#{Lono.root}/",'')
    end
  end
end