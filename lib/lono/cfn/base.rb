require "lono"

class Lono::Cfn
  class Base
    extend Memoist
    include Lono::AwsServices
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

      set_blueprint_root(@blueprint)

      @template_path = "#{Lono.config.output_path}/#{@blueprint}/templates/#{@template}.yml"
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
        yes = rerun_with_iam?(e)
        retry if yes
      rescue Aws::CloudFormation::Errors::ValidationError => e
        if e.message.include?("No updates") # No updates are to be performed.
          puts "WARN: #{e.message}".color(:yellow)
        elsif e.message.include?("UPDATE_ROLLBACK_FAILED") # https://amzn.to/2IiEjc5
          continue_update_rollback
        else
          puts "ERROR: #{e.message}".color(:red)
          exit 1
        end
      end

      return unless @options[:wait]

      success = false
      if !@options[:noop]
        success = status.wait
      end

      # exit code for cfn.rb cli, so there's less duplication
      exit 1 unless success
      success
    end

    def continue_update_rollback_sure?
      puts <<~EOL
        The stack is in the UPDATE_ROLLBACK_FAILED state. More info here: https://amzn.to/2IiEjc5
        Would you like to try to continue the update rollback? (y/N)
      EOL

      sure = @options[:sure] ? "y" : $stdin.gets
      unless sure =~ /^y/
        puts "Exiting without continuing the update rollback."
        exit 0
      end
    end

    def continue_update_rollback
      continue_update_rollback_sure?
      params = {stack_name: @stack_name}
      show_parameters(params, "cfn.continue_update_rollback")
      begin
        cfn.continue_update_rollback(params)
      rescue Aws::CloudFormation::Errors::ValidationError => e
        puts "ERROR5: #{e.message}".red
        exit 1
      end
    end

    def delete_rollback_stack
      rollback = Rollback.new(@stack_name)
      rollback.delete_stack
    end

    def status
      @status ||= Status.new(@stack_name)
    end

    def rerun_with_iam?(e)
      # e.message is "Requires capabilities : [CAPABILITY_IAM]"
      # grab CAPABILITY_IAM with regexp
      capabilities = e.message.match(/\[(.*)\]/)[1]
      confirm = prompt_for_iam(capabilities)
      if confirm =~ /^y/
        @options.merge!(capabilities: [capabilities])
        puts "Re-running: #{command_with_iam(capabilities).color(:green)}"
        true
      else
        puts "Exited"
        exit 1
      end
    end

    def prompt_for_iam(capabilities)
      puts "This stack will create IAM resources.  Please approve to run the command again with #{capabilities} capabilities."
      puts "  #{command_with_iam(capabilities)}"

      puts "Please confirm (y/N)"
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
        ensure_s3_bucket_exist

        build_scripts
        generate_templates # generates with some placeholders for build_files IE: file://app/files/my.rb
        build_files # builds app/files to output/BLUEPRINT/files

        post_process_templates

        unless @options[:noop]
          upload_files
          upload_scripts
          upload_templates
        end
      end

      # Pass down all options to generate_params because it eventually uses template
      param_generator.generate  # Writes the json file in CamelCase keys format
      @@generate_all = param_generator.params    # Returns Array in underscore keys format

      check_for_errors
      @@generate_all
    end

    def ensure_s3_bucket_exist
      bucket = Lono::S3::Bucket.new
      return if bucket.exist?
      bucket.deploy
    end

    def build_scripts
      Lono::Script::Build.new(@blueprint, @options).run
    end

    def build_files
      Lono::AppFile::Build.new(@blueprint, @options).run
    end

    def generate_templates
      Lono::Template::Generator.new(@blueprint, @options.merge(stack: @stack_name)).run
    end

    def param_generator
      generator_options = {
        regenerate: true,
        allow_not_exists: true,
      }.merge(@options)
      generator_options[:stack] ||= @stack_name || @blueprint
      Lono::Param::Generator.new(@blueprint, generator_options)
    end
    memoize :param_generator

    def post_process_templates
      Lono::Template::PostProcessor.new(@blueprint, @options).run
    end

    def upload_templates
      Lono::Template::Upload.new(@blueprint).run
    end

    def upload_scripts
      Lono::Script::Upload.new(@blueprint).run
    end

    def upload_files
      Lono::AppFile::Upload.new(@blueprint).upload
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

      unless status =~ /_COMPLETE$/ || status == "UPDATE_ROLLBACK_FAILED"
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
      if @options[:sure] || @options[:iam]
        ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
      end
    end

    def show_parameters(params, meth=nil)
      params = params.clone.compact
      params[:template_body] = "Hidden due to size... View at: #{pretty_path(@template_path)}"
      params[:template_url] = params[:template_url].sub(/\?.*/,'')
      to = meth || "AWS API"
      puts "Parameters passed to #{to}:"
      puts YAML.dump(params.deep_stringify_keys)
    end

    # Lono always uploads the template to s3 so we can use much larger templates.
    #
    #   template_body: 51,200 bytes - filesystem limit
    #   template_url: 460,800 bytes - s3 limit
    #
    # Reference: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cloudformation-limits.html
    def set_template_body!(params)
      upload = Lono::Template::Upload.new(@blueprint)
      url_path = @template_path.sub("#{Lono.root}/",'')
      url = upload.s3_presigned_url(url_path)
      params[:template_url] = url
      params
    end

    def pretty_path(path)
      path.sub("#{Lono.root}/",'')
    end
  end
end