require 'pathname'

module Lono
  module Core
    autoload :Config, 'lono/core/config'

    @@config = nil
    def config
      @@config ||= Config.new
    end

    def root
      path = ENV['LONO_ROOT'] || '.'
      Pathname.new(path)
    end

    @@env = nil
    def env
      return @@env if @@env
      ufo_env = env_from_profile(ENV['AWS_PROFILE']) || 'development'
      ufo_env = ENV['LONO_ENV'] if ENV['LONO_ENV'] # highest precedence
      @@env = ufo_env
    end

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
