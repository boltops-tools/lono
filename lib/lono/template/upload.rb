require 'erb'
require 'json'
require 'base64'
require 'digest'

class Lono::Template
  class Upload < Lono::AbstractBase
    def initialize(options={})
      super
      @checksums = {}
      @prefix = Lono.env # s3://s3-bucket/development
    end

    def run
      puts "Uploading CloudFormation templates..."
      paths = Dir.glob("#{Lono.config.output_path}/#{@blueprint}/templates/**/*")
      paths.select { |p| File.file?(p) }.each do |path|
        Lono::S3::Uploader.new(path).upload
      end
      puts "Templates uploaded to s3."
    end
  end
end
