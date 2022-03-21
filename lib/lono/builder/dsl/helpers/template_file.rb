module Lono::Builder::Dsl::Helpers
  module TemplateFile
    extend Memoist
    include Lono::Utils::CallLine
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
    def template_file_missing(path)
      logger.warn "WARN: File path not found: #{pretty_path(path)}".color(:yellow)
      call_line = lono_call_line
      DslEvaluator.print_code(call_line) # returns true right now
      ""
    end

    def render_file(path)
      if File.exist?(path)
        RenderMePretty.result(path, context: self)
      else
        template_file_missing(path)
      end
    end
    alias_method :render_path, :render_file
    alias_method :user_data, :render_file
    alias_method :content, :render_file

    def user_data_script
      unless @user_data_script
        script_example = pretty_path("#{@blueprint.root}/template/user_data.sh")
        return <<~EOL
          # @user_data_script variable not set. IE: @user_data_script = "#{script_example}"
          # Also, make sure that "#{script_example}" exists.
        EOL
      end
      user_data(@user_data_script)
    end
  end
end
