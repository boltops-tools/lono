require 'erb'
require 'json'
require 'base64'
require 'digest'

class Lono::Builder::Template
  class Upload < Lono::CLI::Base
    def initialize(options={})
      super
      @checksums = {}
      @prefix = Lono.env # s3://s3-bucket/development
    end

    def run
      paths = Dir.glob("#{Lono.root}/output/#{@blueprint.name}/template.yml")
      paths.select { |p| File.file?(p) }.each do |path|
        Lono::S3::Uploader.new(path).upload
      end
    end
  end
end
