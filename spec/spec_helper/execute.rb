module SpecHelper
  module Execute
    def execute(cmd)
      show_command = ENV['LONO_DEBUG_SPECS'] || ENV['SHOW_COMMAND']
      puts "Running: #{cmd}" if show_command
      out = `#{cmd}`
      puts out if show_command
      out
    end
    alias_method :sh, :execute
  end
end
