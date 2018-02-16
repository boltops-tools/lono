require 'yaml'

module Lono
  class Setting
    def initialize(check_lono_project=true)
      @check_lono_project = check_lono_project
    end

    # data contains the settings.yml config.  The order or precedence for settings
    # is the project lono/settings.yml and then the ~/.lono/settings.yml.
    def data
      return @data if @data

      if @check_lono_project && !File.exist?(project_settings_path)
        puts "ERROR: No settings file at #{project_settings_path}.  Are you sure you are in a project with lono setup?".colorize(:red)
        exit 1
      end

      # project based settings files
      project = load_file(project_settings_path)

      user_file = "#{ENV['HOME']}/.lono/settings.yml"
      user = File.exist?(user_file) ? YAML.load_file(user_file) : {}

      default_file = File.expand_path("../default/settings.yml", __FILE__)
      default = YAML.load_file(default_file)

      @data = default.deep_merge(user.deep_merge(project))[Lono.env]
    end

    # Special helper method to support multiple formats for s3_path setting.
    # Format 1: Simple String
    #
    #   development:
    #     s3_path: mybucket/path/to/folder
    #
    # Format 2: Hash
    #
    #   development:
    #     s3_path:
    #       default: mybucket/path/to/folder
    #       dev_profile1: mybucket/path/to/folder
    #       dev_profile1: another-bucket/storage/path
    #
    def s3_path
      s3_path = data['s3_path']
      return s3_path if s3_path.nil? or s3_path.is_a?(String)

      # If reach here then the s3_path is a Hash
      options = s3_path
      options["default"]
      options[ENV['AWS_PROFILE']] || s3_path["default"]
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
