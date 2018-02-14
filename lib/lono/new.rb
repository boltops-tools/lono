module Lono
  class New < Sequence
    autoload :Helper, 'lono/new/helper'
    include Helper

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
      puts "Creating new project called #{project_name}."
      directory ".", "#{@cwd}/#{project_name}"

      destination_root = "#{@cwd}/#{project_name}"
      self.destination_root = destination_root
      FileUtils.cd("#{@cwd}/#{project_name}")
    end

    def make_executable
      chmod("exe", 0755 & ~File.umask, verbose: false) if File.exist?("exe")
    end

    def bundle_install
      return unless options[:bundle]

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
Congrats 🎉 You have successfully created a lono project.

To launch an example CloudFormation stack:

  cd #{project_name}
  lono cfn create example

To generate the CloudFormation template:

  lono generate

The templates will be generated to the output folder.

More info: http://lono.cloud/
EOL
    end
  end
end
