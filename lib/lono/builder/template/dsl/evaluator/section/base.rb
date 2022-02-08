module Lono::Builder::Template::Dsl::Evaluator::Section
  class Base
    include Lono::Builder::Template::Dsl::Evaluator::Fn
    include Lono::Builder::Template::Dsl::Evaluator::Helpers
    include Lono::Builder::Template::Dsl::Evaluator::Stringify

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
      Lono::Builder::Template::Dsl::Evaluator::Squeezer.new(data).squeeze
    end
  end
end
