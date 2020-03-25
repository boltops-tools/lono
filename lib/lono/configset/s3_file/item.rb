module Lono::Configset::S3File
  # Holds metadata about the item in the regsitry.
  class Item
    include Lono::Utils::Item::FileMethods

    attr_reader :name, :configset, :root
    def initialize(name, options={})
      @name, @options = name, options
      @blueprint = options[:blueprint]
      @configset = options[:configset]
      @root = options[:root]
      @type = options[:type] || 'file'
    end

    def src_path
      "#{@root}/lib/files"
    end

    def output_path
      "#{Lono.config.output_path}/#{@blueprint}/configsets/#{@configset}/files/#{@name}"
    end

    def replacement_value
      aws_data = AwsData.new
      # "https://s3.amazonaws.com/#{Lono::S3::Bucket.name}/#{s3_path}"
      # "https://lono-bucket-12di8xz5sy72z.s3-us-west-2.amazonaws.com/stuff/s3-antivirus.tgz"
      "https://#{Lono::S3::Bucket.name}.s3-#{aws_data.region}.amazonaws.com/#{s3_path}"
    end
  end
end
