module Lono
  module Bundler
    extend Memoist

    # Looks like for zeitwerk module autovivification to work `bundle exec` must be called.
    # This allows zeitwork module autovivification to work even if the user has not called lono with `bundle exec lono`.
    # Bundler.setup is essentially the same as `bundle exec`
    # Reference: https://www.justinweiss.com/articles/what-are-the-differences-between-irb/
    #
    def setup
      return unless gemfile?
      Kernel.require "bundler/setup"
      ::Bundler.setup # Same as Bundler.setup(:default)
    rescue LoadError => e
      handle_error(e)
    end

    def require
      return unless gemfile?
      Kernel.require "bundler/setup"
      ::Bundler.require(*bundler_groups)
    rescue LoadError => e
      handle_error(e)
    end

    def handle_error(e)
      puts e.message
      return if e.message.include?("already activated")
      puts <<~EOL.color(:yellow)
        WARNING: Unable to require "bundler/setup"
        There may be something funny with your ruby and bundler setup.
        You can try upgrading bundler and rubygems:

            gem update --system
            gem install bundler

        Here are some links that may be helpful:

        * https://bundler.io/blog/2019/01/03/announcing-bundler-2.html

        Also, running bundle exec in front of your command may remove this message.
      EOL
    end

    def gemfile?
      ENV['BUNDLE_GEMFILE'] || File.exist?("Gemfile")
    end

    def bundler_groups
      [:default, Lono.env.to_sym]
    end

    extend self

    @@logger = nil
    def logger
      config.logger
    end

    def logger=(v)
      @@logger = v
    end

    def config
      Config.instance.config
    end

    # DSL is evaluated once lazily when it get used
    def dsl
      dsl = Dsl.new
      dsl.run
      dsl
    end
    memoize :dsl

    @@update_mode = false
    def update_mode
      @@update_mode
    end
    alias_method :update_mode?, :update_mode

    def update_mode=(v)
      @@update_mode = v
    end
  end
end

LB = Lono::Bundler
