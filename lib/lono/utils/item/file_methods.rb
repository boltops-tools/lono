module Lono::Utils::Item
  module FileMethods
    def exist?
      File.exist?(output_path)
    end

    def directory?
      File.directory?(output_path)
    end

    def file?
      File.file?(output_path)
    end

    def s3_path
      path = zip_file_path.gsub("#{Lono.root}/",'') # remove Lono.root
      "#{Lono.env}/#{path}"
    end

    # full path
    def zip_file_path
      "#{File.dirname(output_path)}/#{zip_file_name}"
    end

    def zip_file_name
      "#{File.basename(output_path)}-#{@type}-#{Lono::Md5.sum(output_path)}.zip"
    end
  end
end
