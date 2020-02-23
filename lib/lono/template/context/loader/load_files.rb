module Lono::Template::Context::Loader
  module LoadFiles
    # Load custom helper methods from project
    def load_files(root)
      paths = Dir.glob("#{root}/**/*.rb")
      paths.sort_by! { |p| p.size } # so namespaces are loaded first
      paths.each do |path|
        # lib = gem extensions
        # app = project extensions
        filename = path.sub(%r{.*/lib/},'').sub(%r{.*/app/helpers/},'').sub('.rb','')
        module_name = filename.camelize

        # Prepend a period so require works LONO_ROOT is set to a relative path without a period.
        #
        # Example: LONO_ROOT=tmp/lono_project
        first_char = path[0..0]
        path = "./#{path}" unless %w[. /].include?(first_char)

        require path
        self.class.send :include, module_name.constantize
      end
    end
  end
end
