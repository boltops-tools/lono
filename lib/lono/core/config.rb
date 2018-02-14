module Lono::Core
  class Config
    PATHS = {
      helpers_path: "app/helpers",
      partials_path: "app/partials",
      scripts_path: "app/scripts",
      stacks_path: "app/stacks",
      templates_path: "app/templates",
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
