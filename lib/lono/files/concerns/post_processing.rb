module Lono::Files::Concerns
  module PostProcessing
    extend Memoist

    def build
      Lono::Files::Builder.new(@options.merge(files: self)).run
    end

    def compress
      Lono::Files::Compressor.new(@options.merge(files: self)).run
    end

    def upload
      uploader.upload # Lono::S3::Uploader#upload
    end

    delegate :s3_path, :s3_key, to: :uploader
    def uploader
      Lono::S3::Uploader.new(zip_path)
    end
    memoize :uploader

    def zip_name
      "#{File.basename(full_path)}-#{Lono::Md5.sum(full_path)}.zip"
    end

    def zip_path
      "#{File.dirname(output_path)}/#{zip_name}"
    end

    def output_path
      "#{Lono.root}/output/#{@blueprint.name}/#{path}"
    end
  end
end
