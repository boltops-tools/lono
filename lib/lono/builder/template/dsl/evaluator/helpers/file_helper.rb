module Lono::Builder::Template::Dsl::Evaluator::Helpers
  module FileHelper
    extend Memoist

    def user_data(path)
      render_file(Lono.config.paths.user_data, path)
    end

    def user_data_script
      unless @user_data_script
        return <<~EOL
          # @user_data_script variable not set. IE: @user_data_script = "config/#{@blueprint.name}/user_data/boostrap.sh"
          # Also, make sure that "config/#{@blueprint.name}/user_data/boostrap.sh" path you're using exists.
        EOL
      end

      if File.exist?(@user_data_script)
        render_path(@user_data_script)
      else
        message = "WARN: #{@user_data_script} not found"
        logger.info message.color(:yellow)
        "# #{message}"
      end
    end

    def render_file(folder, path)
      path = "#{folder}/#{path}"
      if File.exist?(path)
        render_path(path)
      else
        message = "WARNING: path #{path} not found"
        logger.info message.color(:yellow)
        logger.info "Called from:"
        logger.info caller[2]
        message
      end
    end
    memoize :render_file

    def render_path(path)
      RenderMePretty.result(path, context: self)
    end
  end
end
