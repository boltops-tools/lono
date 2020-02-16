module Lono
  class Conventions
    attr_reader :stack, :blueprint, :template, :param
    def initialize(options)
      @options = options
      @stack, @blueprint, @template, @param = naming_conventions(options)
    end

    def naming_conventions(options)
      o = options.deep_symbolize_keys
      stack = o[:stack]
      blueprint = o[:blueprint] || o[:stack]
      template = o[:template] || blueprint
      param = o[:param] || template || blueprint
      stack ||= blueprint # fallback for commands that dont take stack name. IE: lono generate
      [stack, blueprint, template, param]
    end

    def values
      [@stack, @blueprint, @template, @param]
    end
  end
end
