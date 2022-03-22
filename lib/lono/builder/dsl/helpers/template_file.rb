module Lono::Builder::Dsl::Helpers
  module TemplateFile
    extend Memoist
    include Lono::Utils::CallLine
    include Lono::Utils::Pretty

    # Do not memoize :template_file - it'll hide the template_file_missing error
    def template_file(path)
      path = "#{@blueprint.root}/#{path}" unless path.starts_with?('/')
      if File.exist?(path)
        RenderMePretty.result(path, context: self)
      else
        template_file_missing(path)
      end
    end
    alias_method :render_file, :template_file
    alias_method :render_path, :template_file
    alias_method :user_data, :template_file
    alias_method :content, :template_file


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

    def user_data_script
      path = @user_data_script || @user_data_script_path
      unless path
        # script_example = pretty_path("#{@blueprint.root}/template/bootstrap.sh")
        script_example = "bootstrap.sh"
        return <<~EOL
          # @user_data_script_path variable not set. IE: @user_data_script_path = "#{script_example}"
          # Also, make sure that "#{script_example}" exists.
        EOL
      end
      user_data(path)
    end
    alias_method :user_data_script_path, :user_data_script
  end
end
