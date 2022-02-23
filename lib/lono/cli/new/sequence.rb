require 'fileutils'
require 'active_support'
require 'active_support/core_ext/string'
require 'thor'
require 'bundler'

class Lono::CLI::New
  class Sequence < Thor::Group
    include Concerns
    include Lono::Utils::Logging
    include Thor::Actions

  private
    def self.set_template_source(folder)
      path = File.expand_path("../../../templates/#{folder}", __dir__)
      source_root path
    end

    def set_template_source(*paths)
      paths = paths.flatten.map do |path|
        File.expand_path("../../../templates/#{path}", __dir__)
      end
      set_template_paths(paths)
    end

    def set_template_paths(*paths)
      paths.flatten!
      # https://github.com/erikhuda/thor/blob/34df888d721ecaa8cf0cea97d51dc6c388002742/lib/thor/actions.rb#L128
      instance_variable_set(:@source_paths, nil) # unset instance variable cache
      # Using string with instance_eval because block doesnt have access to path at runtime.
      instance_eval %{
        def self.source_paths
          #{paths.flatten.inspect}
        end
      }
    end

    def git_installed?
      system("type git > /dev/null 2>&1")
    end

    def run_git?
      options[:git] && git_installed?
    end

    def run_git_init
      return unless run_git?
      puts "=> Initialize git repo"
      run("git init")
    end
  end
end
