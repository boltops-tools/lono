module Lono::Builder::Configset::Definition::Dsl::Syntax
  module Content
    def content_file(path)
      content_path = "#{content_file_root}/content"
      file = "#{content_path}/#{path}"
      if File.exist?(file)
        IO.read(file)
      else
        "File not found: #{file}"
      end
    end

  private
    def content_file_root
      if @configset
        @configset.root
      else
        @blueprint.root
      end
    end
  end
end
