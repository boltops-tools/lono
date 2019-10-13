module Lono::Core
  class Config
    PATHS = {
      definitions_path: "app/definitions",
      helpers_path: "app/helpers",
      content_path: "app/content",
      partials_path: "app/partials",
      scripts_path: "app/scripts",
      templates_path: "app/templates",
      user_data_path: "app/user_data",
    }
    PATHS.each do |meth, path|
      define_method meth do
        "#{Lono.blueprint_root}/#{path}"
      end
    end

    def output_path
      "#{Lono.root}/output"
    end
  end
end
