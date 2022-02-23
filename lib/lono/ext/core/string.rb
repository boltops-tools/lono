module Lono
  refine String do
    def camelcase
      self.underscore.camelize
    end
  end
end

using Lono
