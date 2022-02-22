class Lono::CLI
  class Build < Base
    delegate :param_path, to: :param_builder

    # Use class variable to cache this only runs once across all classes. base.rb, diff.rb, preview.rb
    def all
      ensure_s3_bucket_exist unless build_only?
      pre_build
      template_builder.run # build with some placeholders for build_files IE: file://app/files/my.rb
      post_build
      upload unless build_only?

      parameters = param_builder.build  # Writes the json file in CamelCase keys format
      logger.info "" # newline
      parameters
    end
    memoize :all

    def parameters
      all
    end

    def build_only?
      ENV['LONO_BUILD_ONLY'] || @options[:build_only]
    end

    def pre_build
      build_scripts
    end

    def post_build
      return if @options[:source]
      build_files # builds app/files to output/BLUEPRINT/files
      post_process_template
    end

    def ensure_s3_bucket_exist
      bucket = Lono::S3::Bucket.new
      return if bucket.exist?
      bucket.deploy
    end

    def build_scripts
      Lono::Script::Build.new(@options).run
    end

    def build_files
      Lono::AppFile::Build.new(@options).run
      Lono::Configset::S3File::Build.new(@options).run # copies files to the output folder
    end

    def post_process_template
      # support for file://app/files/lambda_layer replacement
      # TODO: Lono::Builder::Template::PostProcessor.new(@options).run
    end

    def upload
      upload_files
      upload_scripts
      upload_templates
    end

    def upload_templates
      Lono::Builder::Template::Upload.new(@options).run
    end

    def upload_scripts
      Lono::Script::Upload.new(@options).run
    end

    def upload_files
      Lono::AppFile::Upload.new(@options).upload
      Lono::Configset::S3File::Upload.new(@options).upload
    end

    def param_builder
      o = {
        regenerate: true,
        allow_not_exists: true,
      }.merge(@options)
      o = HashWithIndifferentAccess.new(o)
      Lono::Builder::Param.new(o)
    end
    memoize :param_builder

    def template_builder
      Lono::Builder::Template.new(@options) # write templates to disk
    end
    memoize :template_builder
  end
end
