class Lono::CLI
  class Bundle < Abstract
    def run
      Lono::Bundler::CLI.start(args)
    end

    # Allows bundle to be called without install. So both work:
    #
    #    lono bundle
    #    lono bundle install
    #
    def args
      args = @options[:args]
      if args.empty? or args.first.include?('--')
        args.unshift("install")
      end
      args = ["bundle"] + args
      args
    end
  end
end
