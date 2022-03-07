module Lono::Files::Concerns
  module PostProcessing
    extend Memoist

    def build
      Lono::Files::Builder.new(@options.merge(files: self)).run
    end

    def build_lambda_layer(cfn)
      Lono::Files::Builder::LambdaLayer.new(@options.merge(files: self, cfn: cfn)).run
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
      name = File.basename(full_path)
      name << "-layer" if layer
      "#{name}-#{Lono::Md5.sum(full_path)}.zip"
    end

    def zip_path
      "#{File.dirname(output_path)}/#{zip_name}"
    end

    def output_path
      if layer
        # For Lambda Layer the final output path is the opt folder, where final artifact is zipped
        "#{Lono.root}/output/#{@blueprint.name}/layer/#{path}/opt" # Note: layer and opt
      else
        # For normal files the final output path in the compiled path
        compiled_path
      end
    end

    # Also used by LambdaLayer::RubyPackager#compiled_area
    def compiled_path
      "#{Lono.root}/output/#{@blueprint.name}/normal/#{path}"
    end
  end
end
