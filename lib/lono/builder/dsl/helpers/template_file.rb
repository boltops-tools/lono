module Lono::Builder::Dsl::Helpers
  module TemplateFile
    extend Memoist
    include Lono::Utils::Pretty

    def template_file(path)
      path = "#{@blueprint.root}/#{path}"
      if File.exist?(path)
        render_file(path)
      else
        template_file_missing(path)
      end
    end
    # do not memoize :template_file - it'll hide the template_file_missing error

    # Caller lines are different for OSes:
    #
    #   windows: "C:/Ruby31-x64/lib/ruby/gems/3.1.0/gems/lono-1.1.1/lib/lono/builder.rb:34:in `build'"
    #   linux: "/home/ec2-user/.rvm/gems/ruby-3.0.3/gems/lono-1.1.1/lib/lono/compiler/dsl/syntax/mod.rb:4:in `<module:Mod>'"
    #
    class TempleFileNotFoundError < StandardError; end
    def template_file_missing(path)
      message = "ERROR: path #{pretty_path(path)} not found"
      caller_line = caller.find { |l| l =~ %r{/blueprints/} } # TODO: show code itself
      logger.error message.color(:red)
      logger.error "Called from:"
      logger.error "    #{pretty_path(caller_line)}"
      # Raise an error so Dsl::Evaluator#template_evaluation_error provides user friendly info
      raise TempleFileNotFoundError.new
    end

    def render_file(path)
      if File.exist?(path)
        RenderMePretty.result(path, context: self)
      else
        lines = caller.select { |l| l.include?(Lono.root.to_s) } # TODO: show code itself
        caller_line = pretty_path(lines.first)
        message =<<~EOL
          WARN: #{pretty_path(path)} does not exist
          Called from: #{caller_line}
        EOL
        logger.info message.color(:yellow)
        message
      end
    end
    alias_method :render_path, :render_file

    def user_data_script
      unless @user_data_script
        script_example = pretty_path("#{@blueprint.root}/template/user_data.sh")
        return <<~EOL
          # @user_data_script variable not set. IE: @user_data_script = "#{script_example}"
          # Also, make sure that "#{script_example}" exists.
        EOL
      end

      if File.exist?(@user_data_script)
        render_file(@user_data_script)
      else
        message = "WARN: #{@user_data_script} not found"
        logger.info message.color(:yellow)
        "# #{message}"
      end
    end
  end
end
