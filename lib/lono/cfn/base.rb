require "lono"

class Lono::Cfn
  class Base < Lono::AbstractBase
    extend Memoist
    include Lono::AwsServices
    include Lono::Utils::Sure

    def starting_message
      action = self.class.to_s.split('::').last
      puts "#{action} #{@stack.color(:green)} stack..."
    end

    def run
      starting_message
      parameters = generate_all
      begin
        check_registration
        save(parameters) # defined in the sub class
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

    def check_registration
      Lono::Registration::Check.new.check
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
      options = {stack_name: @stack}
      show_options(options, "cfn.continue_update_rollback")
      begin
        cfn.continue_update_rollback(options)
      rescue Aws::CloudFormation::Errors::ValidationError => e
        puts "ERROR5: #{e.message}".color(:red)
        exit 1
      end
    end

    def delete_rollback_stack
      rollback = Rollback.new(@stack)
      rollback.delete_stack
    end

    def status
      Status.new(@stack)
    end
    memoize :status

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

    def generate_all
      Lono::Generate.new(@options).all
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
        resp = cfn.describe_stacks(stack_name: @stack)
        tags = resp.stacks.first.tags
        tags = tags.map(&:to_h)
      end

      tags
    end

    def exit_unless_updatable!
      return true if testing_update?
      return false if @options[:noop]

      status = stack_status
      unless status =~ /_COMPLETE$/ || status == "UPDATE_ROLLBACK_FAILED"
        puts "Cannot create a change set for the stack because the #{@stack} is not in an updatable state.  Stack status: #{status}".color(:red)
        quit(1)
      end
    end

    # All CloudFormation states listed here:
    # http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-describing-stacks.html
    def stack_status
      return true if testing_update?
      return false if @options[:noop]
      resp = cfn.describe_stacks(stack_name: @stack)
      resp.stacks[0].stack_status
    end

    # To allow mocking in specs
    def quit(signal)
      exit signal
    end

    def capabilities
      return @options[:capabilities] if @options[:capabilities]
      if @options[:sure] || @options[:iam]
        ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
      end
    end

    def show_options(options, meth=nil)
      options = options.clone.compact
      if options[:template_body] # continue_update_rollback
        options[:template_body] = "Hidden due to size... View at: #{pretty_path(template_path)}"
        options[:template_url] = options[:template_url].sub(/\?.*/,'')
      end
      to = meth || "AWS API"
      puts "Parameters passed to #{to}:"
      puts YAML.dump(options.deep_stringify_keys)
    end

    # Lono always uploads the template to s3 so we can use much larger templates.
    #
    #   template_body: 51,200 bytes - filesystem limit
    #   template_url: 460,800 bytes - s3 limit
    #
    # Reference: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cloudformation-limits.html
    def set_template_url!(options)
      upload = Lono::Template::Upload.new(@options)
      url_path = template_path.sub("#{Lono.root}/",'')
      url = upload.s3_presigned_url(url_path)
      url.gsub!(/\.yml.*/, ".yml") # Interesting dont need presign query string. For stack sets it actually breaks it. So removing.
      options[:template_url] = url
      options
    end

    def pretty_path(path)
      path.sub("#{Lono.root}/",'')
    end
  end
end