class Lono::CLI::New
  class Project < Sequence
    argument :name
    set_template_source "project"

    def self.cli_options
      [
        [:bundle, type: :boolean, default: true, desc: "Runs bundle install on the project"],
        [:examples, type: :boolean, default: false, desc: "Also generate blueprint example"],
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
        [:git, type: :boolean, default: true, desc: "Git initialize the project"],
        [:quiet, type: :boolean, desc: "Quiet output."],
      ]
    end
    cli_options.each { |args| class_option(*args) }

    # for specs
    def set_pwd
      @pwd = Dir.pwd
    end

    def create_project
      log "=> Creating new project called #{name}."
      directory ".", "#{@pwd}/#{name}"
    end

    def create_example_blueprint
      return unless @options[:examples]
      # https://github.com/erikhuda/thor/wiki/Invocations
      args = ["demo", "--project", name]
      args += ["--examples"] if @options[:examples]
      args += ["--force"] if @options[:force]
      Blueprint.start(args)
    end

    def bundle_install
      return unless options[:bundle]
      log "=> Installing dependencies with: bundle install"
      ::Bundler.with_unbundled_env do
        bundle = "BUNDLE_IGNORE_CONFIG=1 bundle install"
        bundle << " > /dev/null 2>&1" if @options[:quiet]
        system(bundle, chdir: name)
      end
    end

    def welcome_message
      log <<~EOL
        #{"="*64}
        Congrats 🎉 You have successfully created a lono project.

            cd #{name}

      EOL
      unless @options[:examples]
        log <<~EOL
          To generate a new blueprint:

              lono new blueprint demo --examples

        EOL
      end
      log <<~EOL
        To deploy:

            lono up demo

        More info: https://lono.cloud/
      EOL
    end

  private
    def log(msg)
      logger.info(msg) unless @options[:quiet]
    end

  end
end
