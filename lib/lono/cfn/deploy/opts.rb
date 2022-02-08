class Lono::Cfn::Deploy
  class Opts < Base
    def initialize(blueprint, meth, iam, options={})
      @blueprint, @meth, @iam, @options = blueprint, meth, iam, options
    end

    def values
      # important to use local options variable to not stomp on @options
      options = @options.clone.compact
      options[:capabilities] = @iam.capabilities if @iam.capabilities
      options[:disable_rollback] = disable_rollback if !disable_rollback.nil? && @meth != "create_change_set"
      options[:notification_arns] = notification.arns if notification.arns
      options[:tags] = tags.values unless tags.values.nil?
      options[:template_url] = template_url
      options.reject { |k,v| v.nil? }
    end

    def show
      logger.debug "Options passed to #{@meth}"
      vals = values
      vals[:template_body] = "Hidden due to size... View at: #{pretty_path(@blueprint.output_path)}" if vals[:template_body]
      logger.debug YAML.dump(vals.deep_stringify_keys)
    end

    # Uploads the template to s3 to allow larger templates.
    #
    #   template_body: 51,200 bytes - filesystem limit
    #   template_url:  1MB - s3 limit
    #
    # Reference: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cloudformation-limits.html
    def template_url
      url_path = @blueprint.output_path.sub("#{Lono.root}/",'')
      url = Lono::S3::Uploader.new(url_path).presigned_url
      # Interesting dont need presign query string. For stack sets it actually breaks it. So removing.
      url.gsub!(/\.yml.*/, ".yml")
      url.sub!(/\?.*/,'')
      url
    end
    memoize :template_url

    def disable_rollback
      if !@options[:rollback].nil?
        !@options[:rollback]
      elsif !Lono.config.up.rollback.nil?
        !Lono.config.up.rollback
      end
    end
  end
end
