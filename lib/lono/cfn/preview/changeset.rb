module Lono::Cfn::Preview
  class Changeset < Lono::Cfn::Base
    # Override run from Base superclass, the run method is different enough with Preview
    def run
      puts "Changeset Preview:".color(:green)

      if @options[:noop]
        puts "NOOP CloudFormation preview for #{@stack} update"
        return
      end

      parameters = generate_all
      success = preview_change_set(parameters)
      delete_change_set if success && !@options[:keep] # Clean up and delete the change set
    end

    def preview_change_set(parameters)
      success = create_change_set(parameters)
      display_change_set if success
    end

    def create_change_set(parameters)
      unless stack_exists?(@stack)
        puts "WARN: Cannot create a change set for the stack because the #{@stack} does not exists.".color(:yellow)
        return false
      end
      exit_unless_updatable!

      options = {
        change_set_name: change_set_name,
        stack_name: @stack,
        parameters: parameters,
      }
      options[:tags] = tags unless tags.empty?
      set_template_url!(options)
      show_options(options, "cfn.create_change_set")
      begin
        # Tricky for preview need to set capabilities so that it gets updated. For Base#run save within the begin block already.
        options[:capabilities] = capabilities # ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
        cfn.create_change_set(options)
      rescue Aws::CloudFormation::Errors::InsufficientCapabilitiesException => e
        # If coming from cfn_preview_command automatically add iam capabilities
        cfn_preview_command = ARGV.join(" ").include?("cfn preview")
        if cfn_preview_command
          # e.message is "Requires capabilities : [CAPABILITY_IAM]"
          # grab CAPABILITY_IAM with regexp
          capabilities = e.message.match(/\[(.*)\]/)[1]
          @options.merge!(capabilities: [capabilities])
          retry
        end
        yes = rerun_with_iam?(e)
        retry if yes
      rescue Aws::CloudFormation::Errors::ValidationError => e
        handle_error(e)
      end
      true
    end

    # Example errors:
    # "Template error: variable names in Fn::Sub syntax must contain only alphanumeric characters, underscores, periods, and colons"
    def handle_error(e)
      raise if ENV['FULL_BACKTRACE']

      if e.message =~ /^Parameters: / || e.message =~ /^Template error: /
        puts "Error creating CloudFormation preview because invalid CloudFormation parameters. Full error message:".color(:red)
        puts e.message
        puts "For full backtrace run command again with FULL_BACKTRACE=1"
        quit(1)
      else
        raise
      end
    end

    def display_change_set
      print "Generating CloudFormation Change Set for preview.."
      change_set = describe_change_set
      until change_set_finished?(change_set) do
        change_set = describe_change_set
        sleep 1
        print '.'
      end
      puts

      case change_set.status
      when "CREATE_COMPLETE"
        puts "CloudFormation preview for '#{@stack}' stack update. Changes:"
        changes = change_set.changes.sort_by do |change|
          change["resource_change"]["action"]
        end
        changes.each do |change|
          display_change(change)
        end
      when "FAILED"
        puts "WARN: Fail to create a CloudFormation preview for '#{@stack}' stack update. Reason:".color(:yellow)
        puts change_set.status_reason
        quit(0)
      else
        raise "hell: never come here"
      end
    end

    def delete_change_set
      cfn.delete_change_set(
        change_set_name: change_set_name,
        stack_name: @stack
      )
    end

    def execute_change_set
      cfn.execute_change_set(
        change_set_name: change_set_name,
        stack_name: @stack
      )
    end

    # generates a change set name
    def change_set_name
      @change_set_name ||= "changeset-#{Time.now.strftime("%Y%d%m%H%M%S")}"
    end

  private
    # Private: formats a Aws::CloudFormation::Types::Change in pretty human readable form
    #
    # change  - Aws::CloudFormation::Types::Change
    #
    # Examples
    #
    #   display_change(change)
    #   => Remove AWS::Route53::RecordSet: DnsRecord testsubdomain.sub.tongueroo.com
    #
    # Returns nil
    #
    # change.to_h
    # {:type=>"Resource",
    #  :resource_change=>
    #   {:action=>"Remove",
    #    :logical_resource_id=>"DnsRecord",
    #    :physical_resource_id=>"testsubdomain.sub.tongueroo.com",
    #    :resource_type=>"AWS::Route53::RecordSet",
    #    :scope=>[],
    #    :details=>[]}}
    def display_change(change)
      message = if change.type == "Resource"
        c = change.resource_change
        "#{c.action} #{c.resource_type}: #{c.logical_resource_id} #{c.physical_resource_id}"
      else
        change.to_h
      end

      colors = { Remove: :red, Add: :green, Modify: :yellow }
      action = change.resource_change.action.to_sym
      message = message.color(colors[action]) if colors.has_key?(action)
      puts message
    end

    def change_set_finished?(change_set)
      change_set.status =~ /_COMPLETE/ || change_set.status == "FAILED"
    end

    def describe_change_set
      cfn.describe_change_set(
        change_set_name: change_set_name,
        stack_name: @stack
      )
    end
  end
end
