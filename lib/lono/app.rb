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

      config.log = ActiveSupport::OrderedOptions.new
      config.log.root = Lono.log_root
      config.logger = lono_logger
      config.logger.formatter = Logger::Formatter.new
      config.logger.level = ENV['LONO_LOG_LEVEL'] || :info

      config.names = ActiveSupport::OrderedOptions.new
      config.names.stack = ":APP-:BLUEPRINT-:ENV"
      config.names.output = ActiveSupport::OrderedOptions.new
      config.names.output.stack = ":BLUEPRINT-:ENV" # does not include APP by default. Think this is more common
      config.names.output.expand = true

      config.paths = ActiveSupport::OrderedOptions.new
      config.paths.scripts = "scripts"
      config.paths.content = "content"
      config.paths.helpers = "helpers"
      config.paths.user_data = "user_data"

      config.up = ActiveSupport::OrderedOptions.new
      config.up.capabilities = nil
      config.up.notification_arns = nil
      config.up.rollback = true
      config.up.tags = nil

      config.diff = ActiveSupport::OrderedOptions.new
      config.diff.changeset = true
      config.diff.params = "full"
      config.diff.template = "summary" # summary is same as true

      config.extract_scripts = {}

      config.test = ActiveSupport::OrderedOptions.new
      config.test.framework = "rspec"

      config.layering = ActiveSupport::OrderedOptions.new
      config.layering.names = {}

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
