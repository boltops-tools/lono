class Lono::Extension
  module Helper
    extend Memoist

    def extension_class_name
      extension_underscore_name.camelize
    end

    def extension_underscore_name
      extension_name.underscore
    end
  end
end
