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
      colordiff_installed = system("type colordiff > /dev/null 2>&1")
      unless colordiff_installed
        puts "INFO: colordiff it not available. Recommend installing it."
      end
      colordiff_installed ? "colordiff" : "diff"
    end
  end
end
