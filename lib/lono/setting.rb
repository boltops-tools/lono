require 'yaml'

module Lono
  class Setting
    def initialize(check_lono_project=true)
      @check_lono_project = check_lono_project
    end

    # data contains the settings.yml config.  The order or precedence for settings
    # is the project lono/settings.yml and then the ~/.lono/settings.yml.
    def data
      return @settings_yaml if @settings_yaml

      if @check_lono_project && !File.exist?(project_settings_path)
        puts "ERROR: No settings file at #{project_settings_path}.  Are you sure you are in a project with lono setup?"
        exit 1
      end

      # project based settings files
      project = load_file(project_settings_path)

      user_file = "#{ENV['HOME']}/.lono/settings.yml"
      user = File.exist?(user_file) ? YAML.load_file(user_file) : {}

      default_file = File.expand_path("../default/settings.yml", __FILE__)
      default = YAML.load_file(default_file)

      @settings_yaml = default.deep_merge(user.deep_merge(project))[Lono.env]
    end

  private
    def load_file(path)
      content = RenderMePretty.result(path)
      data = File.exist?(path) ? YAML.load(content) : {}
      # automatically add base settings to the rest of the environments
      data.each do |lono_env, _setting|
        base = data["base"] || {}
        env = data[lono_env] || {}
        data[lono_env] = base.merge(env) unless lono_env == "base"
      end
      data
    end

    def project_settings_path
      "#{Lono.root}/config/settings.yml"
    end
  end
end
