class Object
  # Load custom helper methods from project
  def load_helper_files(dir, type: :blueprint)
    paths = Dir.glob("#{dir}/**/*.rb")
    paths.sort_by! { |p| p.size } # so namespaces are loaded first
    paths.each do |path|
      next unless File.file?(path)

      filename = if type == :project
                   path.sub(%r{.*/helpers/[a-zA-Z\-_]+/},'').sub('.rb','')
                 else # blueprint, configset
                   path.sub(%r{.*/helpers/},'').sub('.rb','')
                 end
      module_name = filename.camelize

      # Prepend a period so require works when LONO_ROOT is set to a relative path without a period.
      #   Example: LONO_ROOT=tmp/lono_project
      first_char = path[0..0]
      path = "./#{path}" unless %w[. /].include?(first_char)

      # Examples:
      #   project:
      #     path:        app/helpers/custom/custom_helper.rb
      #     module_name: CustomHelper
      #   blueprint:
      #     path:        app/blueprints/demo/helpers/outputs.rb
      #     module_name: Outputs
      require path
      if path.include?("_helper.rb")
        self.class.send :include, module_name.constantize
      end
    end
  end
end
