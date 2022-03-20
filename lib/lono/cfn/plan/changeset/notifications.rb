class Lono::Cfn::Plan::Changeset
  class Notifications < Base
    def changes
      old = stack.notification_arns
      new = @change_set.notification_arns
      added = new - old
      removed = old - new
      return if added.empty? && removed.empty?

      logger.info "Changes to notifications"
      log = Proc.new do |k|
        logger.info "    #{k}"
      end
      unless added.empty?
        logger.info "Added:"
        added.each(&log)
      end
      unless removed.empty?
        logger.info "Removed:"
        removed.each(&log)
      end
    end
  end
end
