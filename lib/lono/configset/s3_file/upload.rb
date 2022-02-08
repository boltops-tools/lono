module Lono::Configset::S3File
  class Upload < Lono::CLI::Base
    def upload
      return unless Registry.items.size > 0
      logger.info "Uploading configset files..."

      Registry.items.each do |item|
        Lono::S3::Uploader.new(item.zip_file_path).upload
      end
    end
  end
end
