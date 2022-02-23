require "aws-sdk-core"

module Lono::Builder::Dsl::Helpers
  module Partials
    def template_s3_path(template_name)
      # hi-jacking Uploader for https_url
      template_path = "output/#{@blueprint.name}/templates/#{template_name}.yml"
      Lono::S3::Uploader.new(template_path).s3_https_url
    end

    def template_params(param_name)
      o = {
        allow_not_exists: true
      }.merge(@options)
      o["param"] = param_name
      generator = Lono::CLI::Param::Generator.new(o)
      # do not generate because lono cfn calling logic already generated it we only need the values
      parameters = generator.parameters    # Returns Array in underscore keys format
      # convert Array to simplified hash structure
      parameters.inject({}) do |h, param|
        h.merge(param[:parameter_key] => param[:parameter_value])
      end
    end

    # The partial's path is a relative path.
    #
    # Example:
    # Given file in app/partials/iam/docker.yml
    #
    #   <%= partial("iam/docker", {}, indent: 10) %>
    #   <%= partial("iam/docker.yml", {}, indent: 10) %>
    #
    # If the user specifies the extension then use that instead of auto-adding
    # the detected format.
    def partial(path,vars={}, options={})
      path = partial_path_for(path)
      path = auto_add_format(path)

      instance_variables!(vars)
      result = render_path(path)

      result = indent(result, options[:indent]) if options[:indent]
      result + "\n"
    end

    # Take a hash and makes them instance variables in the current scope.
    # Use this in custom helper methods to make variables accessible to ERB templates.
    def instance_variables!(variables)
      variables.each do |key, value|
        instance_variable_set('@' + key.to_s, value)
      end
    end

    # add indentation
    def indent(text, indentation_amount)
      text.split("\n").map do |line|
        " " * indentation_amount + line
      end.join("\n")
    end

    def partial_exist?(path)
      path = partial_path_for(path)
      path = auto_add_format(path)
      path && File.exist?(path)
    end

    def region
      AwsData.region
    end
    alias_method :current_region, :region

  private
    def auto_add_format(path)
      # Return immediately if user provided explicit extension
      extension = File.extname(path) # current extension
      return path if !extension.empty?

      # Else let's auto detect
      paths = Dir.glob("#{path}.*")

      if paths.size == 1 # non-ambiguous match
        return paths.first
      end

      if paths.size > 1 # ambiguous match
        logger.info "ERROR: Multiple possible partials found:".color(:red)
        paths.each do |path|
          logger.info "  #{path}"
        end
        logger.info "Please specify an extension in the name to remove the ambiguity.".color(:green)
        exit 1
      end

      # Account for case when user wants to include a file with no extension at all
      return path if File.exist?(path) && !File.directory?(path)

      path # original path if this point is reached
    end

    # Bash code that is meant to included in user-data
    def extract_scripts(options={})
      settings = Lono.config.extract_scripts
      options = settings.merge(options)
      # defaults also here in case they are removed from settings
      to = options[:to] || "/opt"
      user = options[:as] || "ec2-user"

      if Dir.glob("#{Lono.config.paths.scripts}/*").empty?
        logger.info "WARN: you are using the extract_scripts helper method but you do not have any scripts.".color(:yellow)
        calling_line = caller[0].split(':')[0..1].join(':')
        logger.info "Called from1: #{calling_line}"
        return ""
      end

      <<~BASH_CODE
        # Generated from the lono extract_scripts helper.
        # Downloads scripts from s3, extract them, and setup.
        mkdir -p #{to}
        aws s3 cp #{scripts_s3_path} #{to}/
        (
          cd #{to}
          tar zxf #{to}/#{scripts_name}
          chown -R #{user}:#{user} #{to}/scripts
        )
      BASH_CODE
    end

    def scripts_name
      File.basename(scripts_s3_path)
    end

    def scripts_s3_path
      upload = Lono::Script::Upload.new(@options)
      upload.s3_dest
    end

    def indent(text, indentation_amount)
      text.split("\n").map do |line|
        " " * indentation_amount + line
      end.join("\n")
    end
  end
end
