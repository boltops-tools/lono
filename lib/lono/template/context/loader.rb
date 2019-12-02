class Lono::Template::Context
  module Loader
    private
    # Variables in base.rb are overridden by their environment specific variables
    # file.  Example, file LONO_ENV=development:
    #
    #   config/variables/base.rb
    #   config/variables/development.rb - will override any variables in base.rb
    #
    def load_variables
      load_variables_file(project_path("base"))

      direct_absolute_form = @options[:variable] # user provided the absolute full path
      direct_relative_form = "#{Lono.root}/#{@options[:variable]}" # user provided the full path within the lono project
      conventional_form = project_path(Lono.env)

      if ENV['LONO_DEBUG_VARIABLE']
        puts "direct_absolute_form: #{direct_absolute_form.inspect}"
        puts "direct_relative_form: #{direct_relative_form.inspect}"
        puts "conventional_form: #{conventional_form.inspect}"
      end

      load_variables_file(direct_absolute_form) if variable_file?(direct_absolute_form)
      load_variables_file(direct_relative_form) if variable_file?(direct_relative_form)
      load_variables_file(conventional_form) if variable_file?(conventional_form)
    end

    def variable_file?(path)
      return if path.nil?
      return path if File.file?(path) # direct lookup with .rb extension
      return "#{path}.rb" if File.file?("#{path}.rb") # direct lookup without .rb extension
    end

    def project_path(name)
      "#{Lono.root}/configs/#{@blueprint}/variables/#{name}.rb"
    end

    # Load the variables defined in config/variables/* to make available in the
    # template blocks in config/templates/*.
    #
    # Example:
    #
    #   `config/variables/base.rb`:
    #     @foo = 123
    #
    #   `app/definitions/base.rb`:
    #      template "mytemplate.yml" do
    #        source "mytemplate.yml.erb"
    #        variables(foo: @foo)
    #      end
    #
    # NOTE: Only able to make instance variables avaialble with instance_eval,
    #   wasnt able to make local variables available.
    def load_variables_file(path)
      # if File.exist?(path)
      #   puts "context.rb loading #{path}"
      # else
      #   puts "context.rb file doesnt exist #{path}"
      # end

      return unless File.exist?(path)

      instance_eval(IO.read(path), path)
    end

    # Load custom helper methods from project
    def load_project_helpers
      Dir.glob("#{Lono.config.helpers_path}/**/*_helper.rb").each do |path|
        filename = path.sub(%r{.*/},'').sub('.rb','')
        module_name = filename.classify

        # Prepend a period so require works LONO_ROOT is set to a relative path
        # without a period.
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