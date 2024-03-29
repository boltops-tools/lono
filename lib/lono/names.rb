module Lono
  class Names
    extend Memoist

    attr_reader :blueprint
    def initialize(options={})
      @options = options
      @blueprint = options[:blueprint]
    end

    def stack
      expansion(Lono.config.names.stack) # IE: :APP-:BLUEPRINT-:ENV
    end
    memoize :stack

    def expansion(string)
      return string unless string.is_a?(String) # in case of nil

      string = string.dup
      vars = string.scan(/:\w+/) # => [":APP", ":BLUEPRINT", :ENV"]
      vars.each do |var|
        string.gsub!(var, var_value(var))
      end
      cleanse(string)
    end

    def var_value(unexpanded)
      name = unexpanded.sub(':','').downcase
      if respond_to?(name)
        send(name).to_s # value
      else
        unexpanded
      end
    end

    def cleanse(string)
      string.sub(/^-+/,'').sub(/-+$/,'') # remove leading and trailing -
            .gsub(%r{-+},'-') # remove double dashes are more. IE: -- => -
            .gsub('_','-')    # underscores are not allowed in CloudFormation stack names
    end

    delegate :app, :role, :env, :extra, to: :lono
    def lono
      Lono
    end
  end
end
