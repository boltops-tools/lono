class Lono::CLI::New
  class Shim < Thor::Group
    include Thor::Actions

    def self.cli_options
      [
        [:path, aliases: %w[p], default: "/usr/local/bin/lono", desc: "path to save the shim script"],
      ]
    end
    cli_options.each { |args| class_option(*args) }

    def self.source_root
      File.expand_path("../../../templates/shim", __dir__)
    end

    def set_vars
      @path = @options[:path]
    end

    def create
      dest = @path
      template "lono", dest
      chmod dest, 0755
    end

    def message
      dir = File.dirname(@path)
      puts <<~EOL
        A lono shim as been generated at #{@path}
        Please make sure that it is found in the $PATH.

        You can double check with:

            which lono

        You should see

            $ which lono
            #{@path}

        If you do not, please add #{dir} to your PATH.
        You can usually do so by adding this line to ~/.bash_profile and opening a new terminal to check.

            export PATH=#{dir}:/$PATH

        Also note, the shim wrapper contains starter code. Though it should generally work for most systems,
        it might require adjustments depending on your system.
      EOL
    end

  private
    def switch_ruby_version_line
      rbenv_installed = system("type rbenv > /dev/null 2>&1")
      if rbenv_installed
        'eval "$(rbenv init -)"'
      end
    end
  end
end
