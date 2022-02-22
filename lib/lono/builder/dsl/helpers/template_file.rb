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
    #   windows: "C:/Ruby31-x64/lib/ruby/gems/3.1.0/gems/terraspace-1.1.1/lib/terraspace/builder.rb:34:in `build'"
    #   linux: "/home/ec2-user/.rvm/gems/ruby-3.0.3/gems/terraspace-1.1.1/lib/terraspace/compiler/dsl/syntax/mod.rb:4:in `<module:Mod>'"
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
      RenderMePretty.result(path, context: template_context)
    end
    memoize :render_file

    def user_data_script
      unless @user_data_script
        return <<~EOL
          # @user_data_script variable not set. IE: @user_data_script = "#{pretty_path(@blueprint.root)}/template/user_data.sh"
          # Also, make sure that "config/#{@blueprint.name}/user_data/boostrap.sh" path you're using exists.
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
