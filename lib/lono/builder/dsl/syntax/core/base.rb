module Lono::Builder::Dsl::Syntax::Core
  class Base
    include Lono::Builder::Util::Stringify
    include Lono::Builder::Dsl::Syntax::Fn

    def initialize(blueprint, *definition)
      @blueprint = blueprint
      @definition = definition.flatten
    end

  private
    def camelize(attributes)
      data = stringify!(attributes)
      clean(data)
    end

    # Remove items with nil value automatically
    def clean(data)
      Squeezer.new(data).squeeze
    end
  end
end
