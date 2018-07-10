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

    # Precedence (highest to lowest)
    #   1. LONO_SUFFIX
    #   2. .current/lono
    #   3. config/settings.yml
    def suffix
      suffix = ENV['LONO_SUFFIX'] # highest precedence
      suffix ||= Cfn::Current.suffix
      unless suffix
        settings = Setting.new.data
        suffix ||= settings["stack_name_suffix"] # lowest precedence
      end

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
