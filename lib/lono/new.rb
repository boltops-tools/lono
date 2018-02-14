module Lono
  class New < Sequence
    argument :project_name

    # Ugly, but when the class_option is only defined in the Thor::Group class
    # it doesnt show up with cli-template new help :(
    # If anyone knows how to fix this let me know.
    # Also options from the cli can be pass through to here
    def self.cli_options
      [
        [:repo, desc: "GitHub repo to use. Format: user/repo"],
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files."],
        [:git, type: :boolean, default: true, desc: "Git initialize the project"],
      ]
    end

    cli_options.each do |args|
      class_option *args
    end

    def create_project
      copy_project
      destination_root = "#{Dir.pwd}/#{project_name}"
      self.destination_root = destination_root
      FileUtils.cd("#{Dir.pwd}/#{project_name}")
    end

    def make_executable
      chmod("bin", 0755 & ~File.umask, verbose: false) if File.exist?("bin")
      chmod("exe", 0755 & ~File.umask, verbose: false) if File.exist?("exe")
    end

    def bundle_install
      Bundler.with_clean_env do
        system("BUNDLE_IGNORE_CONFIG=1 bundle install")
      end
    end

    def git_init
      return if !options[:git]
      return unless git_installed?
      return if File.exist?(".git") # this is a clone repo

      run("git init")
      run("git add .")
      run("git commit -m 'first commit'")
    end

    def user_message
      puts <<-EOL
#{"="*64}
Congrats 🎉 You have successfully created a CLI project.

Test the CLI:

  cd #{project_name}
  exe/#{project_name} hello       # top-level commands
  exe/#{project_name} sub:goodbye # sub commands
  bundle exec rspec

To publish your CLI as a gem:

  1. edit the #{project_name}.gemspec
  2. edit lib/#{project_name}/version.rb
  3. update the CHANGELOG.md

And run:

  rake release

EOL
    end
  end
end
