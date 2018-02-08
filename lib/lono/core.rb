require 'pathname'

module Lono
  module Core
    def env
      LONO_ENV
    end

    def root
      path = ENV['LONO_ROOT'] || '.'
      Pathname.new(path)
    end

    def setup!
      settings = Lono::Settings.new.data
      map = settings['aws_profile_lono_env_map']

      lono_env = map[ENV['AWS_PROFILE']] || map['default'] || 'prod' # defaults to prod
      lono_env = ENV['LONO_ENV'] if ENV['LONO_ENV'] # highest precedence

      Kernel.const_set(:LONO_ENV, lono_env)
    end
  end
end
