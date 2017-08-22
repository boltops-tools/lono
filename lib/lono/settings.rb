class Lono::Settings
  def initialize(project_root=nil)
    @project_root = project_root || '.'
  end

  def data
    return @settings_yaml if @settings_yaml

    project_file = "#{@project_root}/.lono/settings.yml"
    project = File.exist?(project_file) ? YAML.load_file(project_file) : {}

    user_file = "#{ENV['HOME']}/.lono/settings.yml"
    user = File.exist?(user_file) ? YAML.load_file(user_file) : {}

    default_file = File.expand_path("../default/settings.yml", __FILE__)
    default = YAML.load_file(default_file)

    @settings_yaml = default.merge(user.merge(project))
  end


  def s3_path
    s3 = data['s3']
    # s3['default']['path'] - key will always exist because of default lono/settings.yml
    #   defauult value is nil though
    s3[LONO_ENV]['path'] rescue s3['default']['path']
  end
end
