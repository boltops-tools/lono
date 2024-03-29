require "thor"

# Override thor's long_desc identation behavior
# https://github.com/erikhuda/thor/issues/398
class Thor
  module Shell
    class Basic
      def print_wrapped(message, options = {})
        message = "\n#{message}" unless message[0] == "\n"
        stdout.puts message
      end
    end
  end

  module Util
    # Hack to fix issue when -h produces extra lono command in help.  IE:
    #
    # $ bundle exec lono blueprint -h
    # Commands:
    #   ...
    #   lono lono:blueprint:new BLUEPRINT_NAME  <= weird
    #
    # It looks like thor_classes_in is only used to generate the help menu.
    #
    def self.thor_classes_in(*)
      []
    end
  end
end

module Lono
  class Command < Thor
    class << self
      include Lono::Utils::Logging

      def dispatch(m, args, options, config)
        # Lono.argv provides consistency when lono is being called by rspec-lono test harness
        Lono.argv = args.clone # important to clone since Thor removes the first argv

        check_version_structure!
        check_project!(args.first)

        # Allow calling for help via:
        #   lono command help
        #   lono command -h
        #   lono command --help
        #   lono command -D
        #
        # as well thor's normal way:
        #
        #   lono help command
        if args.length > 1 && !(args & help_flags).empty?
          args -= help_flags
          args.insert(-2, "help")
        end

        #   lono version
        #   lono --version
        #   lono -v
        version_flags = ["--version", "-v"]
        if args.length == 1 && !(args & version_flags).empty?
          args = ["version"]
        end

        super
      end

      def check_project!(command_name)
        return if subcommand?
        return if command_name.nil?
        return if help_flags.include?(Lono.argv.last) # IE: -h help
        return if non_project_command?
        return if File.exist?("#{Lono.root}/config/app.rb")
        return unless Lono.check_project
        logger.error "ERROR: It doesnt look like this is a lono project. Are you sure you are in a lono project?".color(:red)
        ENV['LONO_TEST'] ? raise : exit(1)
      end

      # Also, using ARGV instead of args because args is called by thor in multiple passes
      # For `lono new project`:
      # * 1st pass: "new"
      # * 2nd pass: "project"
      def non_project_command?
        commands = %w[-h -v --version completion completion_script help new test version]
        commands.include?(ARGV[0])
      end

      def check_version_structure!
        return if non_project_command?
        return unless File.exist?('configs')
        puts "ERROR: Old lono project structure detected".color(:red)
        puts <<~EOL
          It looks like this Lono project with an old structure.
          The old structure does not work with this version of Lono.

          Current Installed Lono Version: #{Lono::VERSION}

          Please upgrade the lono project structure.

          See: https://lono.com/docs/upgrading/version8/
        EOL
        exit 1
      end

      def help_flags
        Thor::HELP_MAPPINGS + ["help"]
      end
      private :help_flags

      def subcommand?
        !!caller.detect { |l| l.include?('in subcommand') }
      end

      # Override command_help to include the description at the top of the
      # long_description.
      def command_help(shell, command_name)
        meth = normalize_command_name(command_name)
        command = all_commands[meth]
        alter_command_description(command)
        super
      end

      def alter_command_description(command)
        return unless command

        # Add description to beginning of long_description
        long_desc = if command.long_description
            "#{command.description}\n\n#{command.long_description}"
          else
            command.description
          end

        # add reference url to end of the long_description
        unless website.empty?
          full_command = [command.ancestor_name, command.name].compact.join('-')
          url = "#{website}/reference/lono-#{full_command}"
          long_desc += "\n\nAlso available at: #{url}"
        end

        command.long_description = long_desc
      end
      private :alter_command_description

      def website
        "http://lono.cloud"
      end

      # https://github.com/erikhuda/thor/issues/244
      # Deprecation warning: Thor exit with status 0 on errors. To keep this behavior, you must define `exit_on_failure?` in `Lono::CLI`
      # You can silence deprecations warning by setting the environment variable THOR_SILENCE_DEPRECATION.
      def exit_on_failure?
        true
      end
    end
  end
end
