class Lono::Cfn::Plan::Changeset
  class Resources < Base
    def changes
      return if @change_set.changes.empty?
      logger.info "Resource Changes"
      changes = @change_set.changes.sort_by do |change|
        change["resource_change"]["action"]
      end
      changes.each do |change|
        display_change(change)
      end
    end

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
        "    #{c.action} #{c.resource_type}: #{c.logical_resource_id} #{c.physical_resource_id}"
      else
        change.to_h
      end

      colors = { Remove: :red, Add: :green, Modify: :yellow }
      action = change.resource_change.action.to_sym
      message = message.color(colors[action]) if colors.has_key?(action)
      logger.info message
    end
  end
end
