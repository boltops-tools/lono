require 'pathname'

module Lono
  module Core
    extend Memoist

    cattr_accessor :argv
    cattr_accessor :check_project, default: true

    # allow testing frameworks to switch root
    cattr_writer :root
    def root
      path = @@root || ENV['LONO_ROOT'] || Dir.pwd
      Pathname.new(path)
    end

    def app
      ENV['LONO_APP']
    end
    memoize :app

    def env
      ENV['LONO_ENV'] || 'dev'
    end
    memoize :env

    def tmp_root
      ENV['LONO_TMP_ROOT'] || "/tmp/lono"
    end
    memoize :tmp_root

    def log_root
      "#{root}/log"
    end

    def configure(&block)
      App.instance.configure(&block)
    end

    # Generally, use the Terraspace.config instead of App.instance.config since it guarantees the load_project_config call
    def config
      App.instance.load_project_config
      App.instance.config
    end
    memoize :config

    # allow different logger when running up all or rspec-lono
    cattr_writer :logger
    def logger
      @@logger ||= config.logger
    end
  end
end
