class Lono::Template::Dsl::Builder
  class Base
    include Fn
    include Helper

    def initialize(*definition)
      @definition = definition.flatten
    end
  end
end
