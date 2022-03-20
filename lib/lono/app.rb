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

      config.hooks = ActiveSupport::OrderedOptions.new
      config.hooks.show = true

      config.layering = ActiveSupport::OrderedOptions.new
      config.layering.names = {}
      config.layering.mode = "full" # simple or fulll. simple does not include region, account, and region/account layers
      config.layering.show = show_layers?

      config.log = ActiveSupport::OrderedOptions.new
      config.log.root = Lono.log_root
      config.logger = lono_logger
      config.logger.formatter = Logger::Formatter.new
      config.logger.level = ENV['LONO_LOG_LEVEL'] || :info

      config.names = ActiveSupport::OrderedOptions.new
      config.names.output = ActiveSupport::OrderedOptions.new
      config.names.stack = ":APP-:ROLE-:BLUEPRINT-:ENV-:EXTRA"

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

    def show_layers?
      ENV['LONO_SHOW_LAYERS'] || parse_for_layering_show
    end
    private :show_layers?

    # Some limitations:
    #
    # * Only parsing one file: .ufo/config.rb
    # * If user is using Ruby code that cannot be parse will fallback to default
    #
    # Think it's worth it so user only has to configure
    #
    #     config.layering.show = true
    #
    def parse_for_layering_show
      return false if Lono::Command.non_project_command?
      lines = IO.readlines("#{Lono.root}/config/app.rb")
      config_line = lines.find { |l| l =~ /config\.layering.show.*=/ && l !~ /^\s+#/ }
      return false unless config_line # default is false
      config_value = config_line.gsub(/.*=/,'').strip.gsub(/["']/,'')
      config_value != "false" && config_value != "nil"
    rescue Exception => e
      if ENV['LONO_DEBUG']
        puts "#{e.class} #{e.message}".color(:yellow)
        puts "WARN: Unable to parse for config.layering.show".color(:yellow)
        puts "Using default: config.layering.show = false"
      end
      false
    end
    memoize :parse_for_layering_show

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
