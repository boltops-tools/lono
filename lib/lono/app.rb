module Lono
  class App
    extend Memoist
    include DslEvaluator
    include Singleton
    include Lono::Utils::Logging

    attr_reader :config
    def initialize
      @config = defaults
    end

    def defaults
      config = ActiveSupport::OrderedOptions.new

      config.allow = ActiveSupport::OrderedOptions.new
      config.allow.envs = nil
      config.allow.regions = nil
      config.deny = ActiveSupport::OrderedOptions.new
      config.deny.envs = nil
      config.deny.regions = nil

      config.layering = ActiveSupport::OrderedOptions.new
      config.layering.names = {}

      config.log = ActiveSupport::OrderedOptions.new
      config.log.root = Lono.log_root
      config.logger = lono_logger
      config.logger.formatter = Logger::Formatter.new
      config.logger.level = ENV['LONO_LOG_LEVEL'] || :info

      config.names = ActiveSupport::OrderedOptions.new
      config.names.output = ActiveSupport::OrderedOptions.new
      config.names.output.expand = true
      config.names.output.stack = ":BLUEPRINT-:ENV" # does not include APP by default. Think this is more common
      config.names.stack = ":APP-:BLUEPRINT-:ENV"

      config.plan = ActiveSupport::OrderedOptions.new
      config.plan.changeset = true
      config.plan.params = "full"
      config.plan.template = "summary" # summary is same as true

      config.seed = ActiveSupport::OrderedOptions.new
      config.seed.where = "config"

      config.test = ActiveSupport::OrderedOptions.new
      config.test.framework = "rspec"

      config.up = ActiveSupport::OrderedOptions.new
      config.up.capabilities = nil
      config.up.notification_arns = nil
      config.up.rollback = true
      config.up.tags = nil

      config
    end

    def lono_logger
      Logger.new(ENV['LONO_LOG_PATH'] || $stderr)
    end
    memoize :lono_logger

    def configure
      yield(@config)
    end

    def load_project_config
      evaluate_file("#{Lono.root}/config/app.rb")
      path = "#{Lono.root}/config/envs/#{Lono.env}.rb"
      evaluate_file(path)
    end
  end
end
