module Lono::AppFile
  class Registry
    # Holds metadata about the item in the regsitry.
    class Item
      attr_reader :name, :options
      def initialize(name, blueprint, options={})
        @name, @blueprint, @options = name, blueprint, options
      end

      def path
        "#{Lono.root}/output/#{@blueprint}/files/#{@name}"
      end

      def directory?
        File.directory?(path)
      end

      def file?
        File.file?(path)
      end

      def s3_path
        file_path = zip_file_path.sub(%r{.*/output/[\w_-]+/files/}, '') # dont use basename. there might be subfolders
        "#{s3_prefix}/#{file_path}"
      end

      # full path
      def zip_file_path
        "#{File.dirname(path)}/#{zip_file_name}"
      end

      def zip_file_name
        "#{File.basename(path)}-#{Lono::Md5.sum(path)}.zip"
      end

    private
      def md5_path
        Lono::Md5.name(path)
      end

      def s3_prefix
        "#{Lono.env}/#{@blueprint}/files" # development/ecs-asg/files
      end
    end
  end
end
