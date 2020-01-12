module Lono
  class Generate < AbstractBase
    # Use class variable to cache this only runs once across all classes. base.rb, diff.rb, preview.rb
    @@parameters = nil
    def all
      return @@parameters if @@parameters

      ensure_s3_bucket_exist
      pre_generate
      generate_templates # generates with some placeholders for build_files IE: file://app/files/my.rb
      post_generate
      upload_templates

      @@parameters = param_generator.generate  # Writes the json file in CamelCase keys format
      check_for_errors
      @@parameters
    end

    def pre_generate
      build_scripts
    end

    def post_generate
      return if @options[:noop]
      return if @options[:source]
      build_files # builds app/files to output/BLUEPRINT/files
      post_process_template
      upload_files
      upload_scripts
    end

    def param_generator
      o = {
        regenerate: true,
        allow_not_exists: true,
      }.merge(@options)
      o = HashWithIndifferentAccess.new(o)
      Lono::Param::Generator.new(o)
    end
    memoize :param_generator

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
    end

    def generate_templates
      Lono::Template::Generator.new(@options).run
    end

    def post_process_template
      Lono::Template::PostProcessor.new(@options).run
    end

    def upload_templates
      Lono::Template::Upload.new(@options).run
    end

    def upload_scripts
      Lono::Script::Upload.new(@options).run
    end

    def upload_files
      Lono::AppFile::Upload.new(@options).upload
    end

    def check_for_errors
      errors = check_files
      unless errors.empty?
        puts "Please double check the command you ran.  There were some errors."
        puts "ERROR: #{errors.join("\n")}".color(:red)
        exit
      end
    end

    def check_files
      errors = []
      unless File.exist?(template_path)
        errors << "Template file missing: could not find #{template_path}"
      end
      errors
    end
  end
end
