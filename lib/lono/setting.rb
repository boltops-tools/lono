require 'yaml'

module Lono
  class Setting
    def initialize(check_lono_project=true)
      @check_lono_project = check_lono_project
    end

    # data contains the settings.yml config.  The order or precedence for settings
    # is the project lono/settings.yml and then the ~/.lono/settings.yml.
    @@data = nil
    def data
      return @@data if @@data

      project_settings_path = lookup_project_settings_path

      # project based settings files
      project = load_file(project_settings_path)

      user_file = "#{ENV['HOME']}/.lono/settings.yml"
      user = load_file(user_file)

      default_file = File.expand_path("../default/settings.yml", __FILE__)
      default = load_file(default_file)

      all_envs = default.deep_merge(user.deep_merge(project))
      all_envs = merge_base(all_envs)
      @@data = all_envs[Lono.env] || all_envs["base"] || {}
    end

    def lookup_project_settings_path
      standalone_path = "#{Lono.root}/config/settings.yml"
      multimode_path = "#{Lono.root}/configs/settings.yml"
      parent_multimode_path = "#{Lono.root}/../../configs/settings.yml"

      settings_path = if File.exist?(standalone_path)
                        standalone_path
                      elsif File.exist?(multimode_path)
                        multimode_path
                      elsif File.exist?(parent_multimode_path)
                        parent_multimode_path
                      end

      if @check_lono_project && !settings_path
        puts "ERROR: No lono settings file found.  Are you sure you are in a project with lono setup?".color(:red)
        exit 1
      end

      settings_path
    end

  private
    def load_file(path)
      return Hash.new({}) unless File.exist?(path)

      content = RenderMePretty.result(path)
      data = YAML.load(content) || {}
      # If key is is accidentally set to nil it screws up the merge_base later.
      # So ensure that all keys with nil value are set to {}
      data.each do |lono_env, _setting|
        data[lono_env] ||= {}
      end
      data
    end

    # automatically add base settings to the rest of the environments
    def merge_base(all_envs)
      base = all_envs["base"] || {}
      all_envs.each do |lono_env, env_settings|
        all_envs[lono_env] = base.merge(env_settings) unless lono_env == "base"
      end
      all_envs
    end
  end
end
