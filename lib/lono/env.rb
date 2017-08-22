class Lono::Env
  def self.setup!(project_root='.')
    settings = Lono::Settings.new(project_root).data
    map = settings['aws_profile_lono_env_map']

    lono_env = map[ENV['AWS_PROFILE']] || 'prod' # defaults to prod
    lono_env = ENV['LONO_ENV'] if ENV['LONO_ENV'] # highest precedence

    Kernel.const_set(:LONO_ENV, lono_env)
  end
end
