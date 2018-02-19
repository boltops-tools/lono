module Lono
  class New < Sequence
    autoload :Helper, 'lono/new/helper'
    autoload :Message, 'lono/new/message'
    include Helper
    include Message

    argument :project_name

    # Ugly, but when the class_option is only defined in the Thor::Group class
    # it doesnt show up with cli-template new help :(
    # If anyone knows how to fix this let me know.
    # Also options from the cli can be pass through to here
    def self.cli_options
      [
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files."],
        [:bundle, type: :boolean, default: true, desc: "Runs bundle install on the project"],
        [:git, type: :boolean, default: true, desc: "Git initialize the project"],
      ]
    end

    cli_options.each do |args|
      class_option *args
    end

    # for specs
    def set_cwd
      @cwd = ENV['TEST'] ? File.dirname(Lono.root) : Dir.pwd
    end

    def create_project
      puts "=> Creating new project called #{project_name}."
      directory ".", "#{@cwd}/#{project_name}"
    end

    def create_empty_directories
      Lono::Core::Config::PATHS.keys.each do |meth|
        empty_directory Lono.config.send(meth)
      end
    end

    # After this commands are executed with the newly created project
    def set_destination_root
      destination_root = "#{@cwd}/#{project_name}"
      self.destination_root = destination_root
      FileUtils.cd(self.destination_root)
    end

    def make_executable
      chmod("exe", 0755 & ~File.umask, verbose: false) if File.exist?("exe")
    end

    def bundle_install
      return unless options[:bundle]

      puts "=> Installing dependencies with: bundle install"
      Bundler.with_clean_env do
        system("BUNDLE_IGNORE_CONFIG=1 bundle install")
      end
    end

    def git_init
      return if !options[:git]
      return unless git_installed?
      return if File.exist?(".git") # this is a clone repo

      puts "=> Initialize git repo"
      run("git init")
      run("git add .")
      run("git commit -m 'first commit'")
    end

    def final_message
      puts welcome_message
    end
  end
end
