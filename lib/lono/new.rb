module Lono
  class New < Sequence
    include Helper

    argument :project_name

    # Ugly, but when the class_option is only defined in the Thor::Group class
    # it doesnt show up with cli-template new help :(
    # If anyone knows how to fix this let me know.
    # Also options from the cli can be pass through to here
    def self.cli_options
      [
        [:bundle, type: :boolean, default: true, desc: "Runs bundle install on the project"],
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files."],
        [:git, type: :boolean, default: true, desc: "Git initialize the project"],
        [:type, default: "dsl", desc: "Blueprint type: dsl or erb"],
      ]
    end

    cli_options.each do |args|
      class_option(*args)
    end

    # for specs
    def set_cwd
      @cwd = Dir.pwd
    end

    def create_project
      puts "=> Creating new project called #{project_name}."
      directory ".", "#{@cwd}/#{project_name}"
    end

    def create_starter_blueprint
      # https://github.com/erikhuda/thor/wiki/Invocations
      Lono::Blueprint::New.start(["demo", "--from-new", "--type", @options[:type], "--project-name", project_name])
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

    def git_init
      return if File.exist?(".git") # this is a clone repo
      run_git_init
    end

    def bundle_install
      return unless options[:bundle]

      puts "=> Installing dependencies with: bundle install"
      Bundler.with_clean_env do
        system("BUNDLE_IGNORE_CONFIG=1 bundle install")
      end
    end

    def git_commit
      run_git_commit
    end

    def welcome_message
      puts <<~EOL
        #{"="*64}
        Congrats 🎉 You have successfully created a lono project.  A starter demo blueprint was created
        and is at blueprints/demo.  Check things out by going into the created infra folder.

          cd #{project_name}

        To generate the blueprint templates without launching a stack, you can run:

          lono generate demo

        The generated files are created at `output/demo/templates` and `output/demo/params`.

        To deploy the CloudFormation stack:

          lono cfn deploy my-demo --blueprint demo

        If you name the stack according to conventions, you can simply run:

          lono cfn deploy demo

        To list and create additional blueprints refer to https://lono.cloud/docs/core/blueprints

        More info: http://lono.cloud/
      EOL
    end
  end
end
