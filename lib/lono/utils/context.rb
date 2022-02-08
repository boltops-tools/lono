module Lono::Utils
  module Context
    extend Memoist

    def context
      Lono::Builder::Context.new(@options)
    end
    memoize :context

    def params_context
      Lono::Builder::Context::Params.new(@options)
    end
    memoize :params_context
  end
end
