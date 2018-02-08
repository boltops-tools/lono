class Lono::Settings
  # The options from the files get merged with the following precedence:
  #
  # current folder - The current folder’s config/settings.yml values take the highest precedence.
  # user - The user’s ~/.lono/settings.yml values take the second highest precedence.
  # default - The default settings bundled with the tool takes the lowest precedence.
  #
  # More info: http://lono.cloud/docs/settings/
  def data
    return @settings_yaml if @settings_yaml

    project_file = "#{Lono.root}/config/settings.yml"
    project = File.exist?(project_file) ? YAML.load_file(project_file) : {}

    user_file = "#{ENV['HOME']}/.lono/settings.yml"
    user = File.exist?(user_file) ? YAML.load_file(user_file) : {}

    default_file = File.expand_path("../default/settings.yml", __FILE__)
    default = YAML.load_file(default_file)

    @settings_yaml = default.merge(user.merge(project))
  end

  # Examples:
  #
  # Using the Lono.env
  # s3:
  #   path:
  #     production: s3://infrastructure-prod/cloudformation
  #     staging: s3://infrastructure-dev/cloudformation
  #
  # Using the AWS_PROFILE
  # s3:
  #   path:
  #     my-prod-profile: s3://infrastructure-prod/cloudformation
  #     my-stag-profile: s3://infrastructure-dev/cloudformation
  #
  def s3_path
    s3 = data['s3']
    s3_path = s3['path']
    # s3_path['default'] - key will always exist because of default lono/settings.yml
    #   default value is nil though
    s3_path[ENV['AWS_PROFILE']] || s3_path[Lono.env] || s3_path['default']
  end
end
