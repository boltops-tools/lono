require "yaml"

class Lono::Blueprint
  class Meta
    extend Memoist

    def initialize(blueprint)
      @blueprint = blueprint
    end

    def config
      Lono::Finder::Blueprint.find(@blueprint)
    end
    memoize :config

    def auto_camelize?(target_section)
      auto_camelize = config.auto_camelize
      # auto_camelize.nil? for backward compatibility
      return true if auto_camelize.nil? || auto_camelize == true

      if auto_camelize == "except_resource"
        return target_section != "resource"
      end

      if auto_camelize.is_a?(Array)
        auto_camelize.include?(target_section)
      end
    end
  end
end
