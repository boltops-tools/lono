class Lono::Cfn::Deploy
  class Notification < Base
    def arns
      arns = @options["notification_arns"] || Lono.config.up.notification_arns
      arns == [''] ? [] : arns # allow removing the notification_arns setting
    end
  end
end
