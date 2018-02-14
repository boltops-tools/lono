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
end

module Lono
  class Command < Thor
    class << self
      def dispatch(m, args, options, config)
        # Allow calling for help via:
        #   lono command help
        #   lono command -h
        #   lono command --help
        #   lono command -D
        #
        # as well thor's normal way:
        #
        #   lono help command
        help_flags = Thor::HELP_MAPPINGS + ["help"]
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
    end
  end
end
