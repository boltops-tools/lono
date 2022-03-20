module Lono
  class Builder < Lono::CLI::Base
    include Lono::Hooks::Concern

    def all
      check_allow!

      parameters = nil
      run_hooks("build") do
        clean
        template_builder.run # build with placeholders IE: LONO://app/files/index.rb
        parameters = param_builder.build  # Writes the json file in CamelCase keys format
      end

      logger.info "" # newline
      parameters
    end
    memoize :all
    alias_method :parameters, :all

    def clean
      Lono::CLI::Clean.new(@options.merge(mute: true)).run
    end

    def check_allow!
      Lono::Builder::Allow.new(@options).check!
    end

    def param_builder
      Lono::Builder::Param.new(@options)
    end
    memoize :param_builder

    def template_builder
      Lono::Builder::Template.new(@options) # write templates to disk
    end
    memoize :template_builder
  end
end
