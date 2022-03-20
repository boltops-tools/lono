module Lono::Builder::Configset
  class Definition < Lono::CLI::Base
    attr_reader :configset
    def initialize(options={})
      super
      @meta = options[:meta]
      @configset = Lono::Configset.new(@meta)
    end

    def evaluate
      strategy_class = configset.path.include?('.rb') ? Dsl : Erb
      strategy = strategy_class.new(@options.merge(path: configset.path))
      metadata = strategy.evaluate
      @configset.metadata = metadata
      @configset
    end
  end
end
