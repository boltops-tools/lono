require 'pathname'

module Lono
  module Core
    extend Memoist

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
      env = env_from_profile(ENV['AWS_PROFILE']) || 'development'
      env = ENV['LONO_ENV'] if ENV['LONO_ENV'] # highest precedence
      env
    end
    memoize :env

    # Overrides AWS_PROFILE based on the Lono.env if set in configs/settings.yml
    # 2-way binding.
    def set_aws_profile!
      return unless settings # Only load if within lono project and there's a settings.yml
      data = settings[Lono.env] || {}
      if data["aws_profile"]
        # puts "Using AWS_PROFILE=#{data["aws_profile"]} from LONO_ENV=#{Lono.env} in configs/settings.yml"
        ENV['AWS_PROFILE'] = data["aws_profile"]
      end
    end

    # Do not use the Setting#data to load the profile because it can cause an
    # infinite loop then if we decide to use Lono.env from within settings class.
    def settings
      setting = Setting.new(false) # check_lono_project to account for `lono new`
      settings_path = setting.lookup_project_settings_path
      return unless settings_path # in case outside of lono project

      YAML.load_file(settings_path)
    end
    memoize :settings

    def lono_pro_removal_check!
      if lono_pro_installed?
        puts "ERROR: A lono-pro gem installation has been detected.".color(:red)
        puts <<~EOL
          The lono-pro gem is now a part of lono itself. The lono-pro gem has been deprecated.
          Please uninstall the lono-pro gem and remove it from your Gemfile to continue.
        EOL
        exit 1
      end
    end

    def lono_pro_installed?
      Lono::Pro::VERSION
      true
    rescue NameError
      false
    end

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
