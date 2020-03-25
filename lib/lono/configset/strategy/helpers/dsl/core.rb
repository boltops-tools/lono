module Lono::Configset::Strategy::Helpers::Dsl
  module Core
    def content_file(path)
      content_path = "#{@root}/lib/content"
      file = "#{content_path}/#{path}"
      if File.exist?(file)
        IO.read(file)
      else
        "File not found: #{file}"
      end
    end

    def s3_key(name)
      Lono::Configset::S3File::Registry.register(name, blueprint: @blueprint, configset: @configset, root: @root)
      "file://configset/#{@configset}/#{name}"
    end
  end
end
