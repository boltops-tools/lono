class Lono::Template
  module Util
    def ensure_parent_dir(path)
      dir = File.dirname(path)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
    end
  end
end
