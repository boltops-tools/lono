module Lono::Cfn::Preview
  module DiffViewer
    def show_diff(existing_path, new_path)
      command = "#{diff_viewer} #{existing_path} #{new_path}"
      puts "Running: #{command}"
      out = `#{command}`
      if out.strip == ''
        puts "There were no differences."
      else
        puts out
      end
    end

    def diff_viewer
      return ENV['LONO_DIFF'] if ENV['LONO_DIFF']
      system("type colordiff > /dev/null") ? "colordiff" : "diff"
    end
  end
end
