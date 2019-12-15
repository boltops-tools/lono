module Lono::Template::Strategy::Dsl::Builder::Helpers
  module FileHelper
    extend Memoist

    def content(path)
      render_file(Lono.config.content_path, path)
    end

    def user_data(path)
      render_file(Lono.config.user_data_path, path)
    end

    def user_data_script
      unless @user_data_script
        return <<~EOL
          # @user_data_script variable not set. IE: @user_data_script = "configs/#{@blueprint}/user-data/boostrap.sh"
          # Also, make sure that "configs/#{@blueprint}/user-data/boostrap.sh" path you're using exists.
        EOL
      end

      if File.exist?(@user_data_script)
        render_path(@user_data_script)
      else
        message = "WARN: #{@user_data_script} not found"
        puts message.color(:yellow)
        "# #{message}"
      end
    end

    def render_file(folder, path)
      path = "#{folder}/#{path}"
      if File.exist?(path)
        render_path(path)
      else
        message = "WARNING: path #{path} not found"
        puts message.color(:yellow)
        puts "Called from:"
        puts caller[2]
        message
      end
    end
    memoize :render_file

    def render_path(path)
      RenderMePretty.result(path, context: self)
    end
  end
end
