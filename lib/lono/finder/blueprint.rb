module Lono::Finder
  class Blueprint < Base
    def type
      "blueprint"
    end

    def detection_path
      "app/templates"
    end
  end
end
