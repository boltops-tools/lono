require 'pathname'

module Lono
  module Core
    extend Memoist
    autoload :Config, 'lono/core/config'

    def config
      Config.new
    end
    memoize :config

    @@root = nil
    def root
      path = @@root || ENV['LONO_ROOT'] || Dir.pwd
      Pathname.new(path)
    end
    memoize :root

    @@blueprint_root = nil
    def blueprint_root; @@blueprint_root ; end
    def blueprint_root=(v) ; @@blueprint_root = v ; end

    def env
      # 2-way binding
      ufo_env = env_from_profile(ENV['AWS_PROFILE']) || 'development'
      ufo_env = ENV['LONO_ENV'] if ENV['LONO_ENV'] # highest precedence
      ufo_env
    end
    memoize :env

    # Overrides AWS_PROFILE based on the Lono.env if set in configs/settings.yml
    # 2-way binding.
    def set_aws_profile!
      return unless settings # Only load if within lono project and there's a settings.yml
      data = settings[Lono.env] || {}
      if data["aws_profile"]
        puts "Using AWS_PROFILE=#{data["aws_profile"]} from LONO_ENV=#{Lono.env} in configs/settings.yml"
        ENV['AWS_PROFILE'] = data["aws_profile"]
      end
    end

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

    # Do not use the Setting#data to load the profile because it can cause an
    # infinite loop then if we decide to use Lono.env from within settings class.
    def settings
      setting = Setting.new(false) # check_lono_project to account for `lono new`
      settings_path = setting.lookup_project_settings_path
      return unless settings_path # in case outside of lono project

      YAML.load_file(settings_path)
    end
    memoize :settings

    private
    def env_from_profile(aws_profile)
      return unless settings
      env = settings.find do |_env, settings|
        settings ||= {}
        profiles = settings['aws_profile']
        profiles && profiles == aws_profile
      end
      env.first if env
    end
  end
end
