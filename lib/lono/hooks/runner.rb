module Lono::Hooks
  class Runner
    include Lono::Utils

    # exposing blueprint and hook so lono hooks have access to them via runner context. IE:
    #
    #     class EnvExporter
    #       def call(runner)
    #         puts "runner.hook #{runner.hook}"
    #       end
    #     end
    #
    # Docs: http://lono.cloud/docs/config/hooks/ruby/#method-argument
    #
    attr_reader :blueprint, :hook
    def initialize(blueprint, hook)
      @blueprint, @hook = blueprint, hook
      @execute = @hook["execute"]
    end

    def run
      case @execute
      when String
        sh(@execute, exit_on_fail: @hook["exit_on_fail"])
      when -> (e) { e.respond_to?(:public_instance_methods) && e.public_instance_methods.include?(:call) }
        executor = @execute.new
      when -> (e) { e.respond_to?(:call) }
        executor = @execute
      else
        logger.warn "WARN: execute option not set for hook: #{@hook.inspect}"
      end

      return unless executor

      meth = executor.method(:call)
      case meth.arity
      when 0
        executor.call # backwards compatibility
      when 1
        executor.call(self)
      else
        raise "The #{executor} call method definition has been more than 1 arguments and is not supported"
      end
    end
  end
end
