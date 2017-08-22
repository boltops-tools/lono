require 'erb'
require 'json'
require 'base64'

class Lono::Template::Upload
  include Lono::Template::AwsServices

  def initialize(options={})
    @options = options
    @project_root = options[:project_root] || '.'
  end

  def run
    ensure_s3_setup!
    paths = Dir.glob("#{@project_root}/output/**/*")
    paths.reject { |p| p =~ %r{output/params} }.
          select { |p| File.file?(p) }.each do |path|
      upload(path)
    end
    say "Templates uploaded to s3."
  end

  def upload(path)
    pretty_path = path.sub(/^\.\//, '')
    key = "#{s3_path}/#{LONO_ENV}/#{pretty_path.sub(/^output\//,'')}"
    s3_full_path = "s3://#{s3_bucket}/#{key}"

    resp = s3.put_object(
      body: IO.read(path),
      bucket: s3_bucket,
      key: key,
      storage_class: "REDUCED_REDUNDANCY"
    ) unless @options[:noop]

    message = "Uploaded: #{pretty_path} to #{s3_full_path}"
    message = "NOOP: #{message}" if @options[:noop]
    say message
  end

  # https://s3.amazonaws.com/mybucket/cloudformation-templates/prod/parent.yml
  def s3_https_url(template_path)
    ensure_s3_setup!
    "https://s3.amazonaws.com/#{s3_bucket}/#{s3_path}/#{LONO_ENV}/#{template_path}"
  end

  # Example:
  #    s3_bucket('s3://mybucket/templates/storage/path') => mybucket
  def s3_bucket
    @s3_full_path.sub('s3://','').split('/').first
  end

  # Example:
  #    s3_bucket('s3://mybucket/templates/storage/path') => templates/storage/path
  def s3_path
    @s3_full_path.sub('s3://','').split('/')[1..-1].join('/')
  end

  # nice warning if the s3 path not found
  def ensure_s3_setup!
    return if @options[:noop]

    settings = Lono::Settings.new(@project_root)
    if settings.s3_path
      @s3_full_path = settings.s3_path
    else
      say "Unable to upload templates to s3 because you have not configured the s3.path option in .lono/settings.yml.".colorize(:red)
      say "Please configure .lono/settings.yml with s3.path.  Refer to http://lono.cloud/docs/settings/ for more help.".colorize(:red)
      exit 1
    end
  end

  def say(message)
    puts message unless @options[:quiet]
  end
end
