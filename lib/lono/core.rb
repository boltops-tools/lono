require 'pathname'

module Lono
  module Core
    extend Memoist
    autoload :Config, 'lono/core/config'

    def config
      Config.new
    end
    memoize :config

    def root
      path = ENV['LONO_ROOT'] || '.'
      Pathname.new(path)
    end
    memoize :root

    def env
      ufo_env = env_from_profile(ENV['AWS_PROFILE']) || 'development'
      ufo_env = ENV['LONO_ENV'] if ENV['LONO_ENV'] # highest precedence
      ufo_env
    end
    memoize :env

    def suffix
      suffix = Current.suffix # TODO: add current concept
      suffix = ENV['LONO_SUFFIX'] if ENV['LONO_SUFFIX'] # highest precedence
      return if suffix&.empty?
      suffix
    end
    memoize :suffix

    private
    # Do not use the Setting class to load the profile because it can cause an
    # infinite loop then if we decide to use Lono.env from within settings class.
    def env_from_profile(aws_profile)
      data = YAML.load_file("#{Lono.root}/config/settings.yml")
      env = data.find do |_env, setting|
        setting ||= {}
        profiles = setting['aws_profiles']
        profiles && profiles.include?(aws_profile)
      end
      env.first if env
    end
  end
end
