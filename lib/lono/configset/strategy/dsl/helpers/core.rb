module Lono::Configset::Strategy::Dsl::Helpers
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
  end
end
