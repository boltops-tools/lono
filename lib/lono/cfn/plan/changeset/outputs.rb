class Lono::Cfn::Plan::Changeset
  class Outputs < Base
    # Not enough info to show value changes. Show whats possible: Added and Removed keys
    def changes
      old_keys = stack.outputs.map { |output| output[:output_key] }
      new_keys = template_output.outputs.map { |k,_| k }
      added_keys = new_keys - old_keys
      removed_keys = old_keys - new_keys
      return if added_keys.empty? && removed_keys.empty?

      logger.info "Changes to outputs"
      log = Proc.new do |k|
        logger.info "    #{k}"
      end
      unless added_keys.empty?
        logger.info "Added:"
        added_keys.each(&log)
      end
      unless removed_keys.empty?
        logger.info "Removed:"
        removed_keys.each(&log)
      end
    end
  end
end
