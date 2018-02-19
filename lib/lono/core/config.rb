module Lono::Core
  class Config
    PATHS = {
      definitions_path: "app/definitions",
      helpers_path: "app/helpers",
      partials_path: "app/partials",
      scripts_path: "app/scripts",
      templates_path: "app/templates",
      user_data_path: "app/user_data",
      params_path: "config/params",
      variables_path: "config/variables",
      output_path: "output",
    }
    PATHS.each do |meth, path|
      define_method meth do
        "#{Lono.root}/#{path}"
      end
    end
  end
end
