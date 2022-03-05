class Lono::CLI
  class Build < Base
    def all
      check_allow!
      Clean.new(@options.merge(mute: true)).run
      ensure_s3_bucket_exist
      template_builder.run # build with placeholders IE: file://app/files/index.rb
      upload_templates
      parameters = param_builder.build  # Writes the json file in CamelCase keys format
      logger.info "" # newline
      parameters
    end
    memoize :all
    alias_method :parameters, :all

    def check_allow!
      Lono::Builder::Allow.new(@options).check!
    end

    def ensure_s3_bucket_exist
      return unless upload?
      bucket = Lono::S3::Bucket.new
      return if bucket.exist?
      bucket.deploy
    end

    def upload_templates
      return unless upload?
      Lono::Builder::Template::Upload.new(@options).run
    end

    def param_builder
      Lono::Builder::Param.new(@options)
    end
    memoize :param_builder

    def template_builder
      Lono::Builder::Template.new(@options) # write templates to disk
    end
    memoize :template_builder

    # Useful for dev and debugging
    def upload?
      ENV['LONO_UPLOAD'] != '0'
    end
  end
end
