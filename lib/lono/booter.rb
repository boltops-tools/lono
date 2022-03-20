module Lono
  module Booter
    def boot
      run_hooks
      Lono::Bundler.require # load plugins
    end

    # Special boot hooks run super early.
    # Useful for setting env vars and other early things.
    #
    #    config/boot.rb
    #    config/boot/dev.rb
    #
    def run_hooks
      run_hook
      run_hook(Lono.env)
      Lono::App::Inits.run_all
    end

    def run_hook(env=nil)
      name = env ? "boot/#{env}" : "boot"
      path = "#{Lono.root}/config/#{name}.rb"
      require path if File.exist?(path)
    end

    extend self
  end
end
