require 'thor'

class Lono::Command < Thor
  class << self
    def dispatch(m, args, options, config)
      # Allow calling for help via:
      #   lono generate help
      #   lono generate -h
      #   lono generate --help
      #   lono generate -D
      #
      # as well thor's nomral setting as
      #
      #   lono help generate
      help_flags = Thor::HELP_MAPPINGS + ["help"]
      if args.length > 1 && !(args & help_flags).empty?
        args -= help_flags
        args.insert(-2, "help")
      end
      super
    end
  end
end
