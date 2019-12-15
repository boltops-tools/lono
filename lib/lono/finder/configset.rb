module Lono::Finder
  class Configset < Base
    def type
      "configset"
    end

    def detection_path
      "lib/configset.*"
    end
  end
end
