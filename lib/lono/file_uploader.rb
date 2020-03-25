module Lono
  class FileUploader < AbstractBase
    extend Memoist

    def initialize(options={})
      super
      @checksums = {}
      @prefix = "#{Lono.env}/#{blueprint}/files" # s3://s3-bucket/folder/development/files
    end

    def upload_all
      puts "Uploading app/files.."
      load_checksums!

      Dir.glob(pattern).each do |path|
        next if ::File.directory?(path)
        Lono::S3::Uploader.new(path).upload
      end
    end
  end
end
