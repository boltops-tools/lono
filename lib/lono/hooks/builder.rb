module Lono::Hooks
  class Builder
    extend Memoist
    include Dsl
    include DslEvaluator
    include Lono::Utils

    # IE: dsl_file: config/hooks.rb
    attr_accessor :name
    def initialize(blueprint, name)
      @blueprint, @name = blueprint, name
      @hooks = {before: {}, after: {}}
    end

    def build
      evaluate_file("#{Lono.root}/config/hooks.rb")
      evaluate_file("#{@blueprint.root}/config/hooks.rb")
      @hooks.deep_stringify_keys!
    end
    memoize :build

    def run_hooks
      build
      run_each_hook("before")
      out = yield if block_given?
      run_each_hook("after")
      out
    end

    def run_each_hook(type)
      hooks = @hooks.dig(type, @name) || []
      hooks.each do |hook|
        run_hook(type, hook)
      end
    end

    def run_hook(type, hook)
      return unless run?(hook)

      id = "#{type} #{@name}"
      label = " label: #{hook["label"]}" if hook["label"]
      logger.info  "Hook: Running #{id} hook#{label}".color(:cyan) if Lono.config.hooks.show
      Runner.new(@blueprint, hook).run
    end

    def run?(hook)
      !!hook["execute"]
    end
  end
end
