module Lono::Finder
  class Extension < Base
    def type
      "extension"
    end

    def detection_path
      "lib/*/helpers"
    end
  end
end
