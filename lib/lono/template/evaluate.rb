class Lono::Template
  module Evaluate
    def evaluate_template_path(path)
      return unless File.exist?(path)

      begin
        instance_eval(File.read(path), path)
      rescue Exception => e
        template_evaluation_error(e)
        puts "\nFull error:"
        raise
      end
    end

    # Prints out a user friendly task_definition error message
    def template_evaluation_error(e)
      lines = e.backtrace.reject { |l| l.include?("/lib/lono/") }
      error_info = lines.first
      path, line_no, _ = error_info.split(':')
      line_no = line_no.to_i
      puts "Error evaluating #{path}:".color(:red)
      puts e.message
      puts "Here's the line in #{path} with the error:\n\n"

      contents = IO.read(path)
      content_lines = contents.split("\n")
      context = 5 # lines of context
      top, bottom = [line_no-context-1, 0].max, line_no+context-1
      spacing = content_lines.size.to_s.size
      content_lines[top..bottom].each_with_index do |line_content, index|
        line_number = top+index+1
        if line_number == line_no
          printf("%#{spacing}d %s\n".color(:red), line_number, line_content)
        else
          printf("%#{spacing}d %s\n", line_number, line_content)
        end
      end
    end
  end
end
