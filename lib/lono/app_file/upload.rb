module Lono::AppFile
  class Upload < Base
    def upload
      return unless Registry.items.size > 0
      logger.info "Uploading app/files..."

      Registry.items.each do |item|
        Lono::S3::Uploader.new(item.zip_file_path).upload
      end
    end
  end
end
