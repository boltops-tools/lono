require "aws-sdk-core"

class Lono::Builder::Template
  module Helpers
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

    # Adjust the partial path so that it will use app/user_data
    def user_data(path,vars={}, options={})
      options.merge!(user_data: true)
      partial(path,vars, options)
    end

    def current_region
      region = Aws.config[:region]
      region ||= ENV['AWS_REGION']
      return region if region

      default_region = 'us-east-1' # fallback if default not found in ~/.aws/config
      if ENV['AWS_PROFILE']
        path = "#{ENV['HOME']}/.aws/config"
        if File.exist?(path)
          lines = IO.readlines(path)
          capture_default, capture_current = false, false
          lines.each do | line|
            if line.include?('[default]')
              capture_default = true # next line
              next
            end
            if capture_default && line.match(/region = /)
              # over default from above
              default_region = line.split(' = ').last.strip
              capture_default = false
            end

            md = line.match(/\[profile (.*)\]/)
            if md && md[1] == ENV['AWS_PROFILE']
              capture_current = true
              next
            end
            if capture_current && line.match(/region = /)
              region = line.split(' = ').last.strip
              capture_current = false
            end
          end
        end

        region ||= default_region
        return region if region
      end

      'us-east-1' # default
    end

  private
    def render_path(path)
      RenderMePretty.result(path, context: self)
    end

    def user_data_path_for(path)
      "#{Lono.config.paths.user_data}/#{path}"
    end

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
        logger.info "Called from: #{calling_line}"
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

    def setting
      @setting ||= Lono::Setting.new
    end
  end
end
