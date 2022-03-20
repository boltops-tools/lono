module Lono::Bundler
  class Dsl
    include DslEvaluator
    include Syntax

    class_attribute :meta, default: {global: {}, components: []}

    def run
      evaluate_file(LB.config.lonofile)
      self
    end

    def meta
      self.class.meta
    end

    def global
      meta[:global]
    end
  end
end
