class Lono::Builder::Allow
  class Base < Lono::CLI::Base
    include Lono::App::CallableOption::Concern

    def check!
      messages = []
      unless allowed?
        messages << message # message is interface method
      end
      unless messages.empty?
        puts "ERROR: The configs do not allow this.".color(:red)
        puts messages
        exit 1
      end
    end

    def allowed?
      if allows.nil? && denys.nil?
        true
      elsif denys.nil?
        allows.include?(check_value)
      elsif allows.nil?
        !denys.include?(check_value)
      else
        allows.include?(check_value) && !denys.include?(check_value)
      end
    end

    def allows
      callable_option(
        config_name: "config.allow.#{config_name}",
        config_value: config.dig(:allow, config_name),
        passed_args: [@blueprint],
      )
    end

    def denys
      callable_option(
        config_name: "config.deny.#{config_name}",
        config_value: config.dig(:deny, config_name),
        passed_args: [@blueprint],
      )
    end

  private
    def config
      Lono.config
    end

    def config_name
      self.class.to_s.split('::').last.underscore.pluralize.to_sym # ActiveSuport::HashWithIndifferentAccess#dig requires symbol
    end
  end
end
