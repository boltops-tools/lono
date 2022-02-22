module Lono::Utils
  module Contexts
    extend Memoist

    def template_context
      Lono::Builder::Context::Template.new(@options)
    end
    memoize :template_context

    def params_context
      Lono::Builder::Context::Params.new(@options)
    end
    memoize :params_context
  end
end
