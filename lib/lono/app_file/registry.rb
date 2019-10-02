module Lono::AppFile
  class Registry
    @@items = []
    class << self
      def register(name, blueprint, options={})
        @@items << Item.new(name, blueprint, options) unless @@items.detect { |i| i.name == name }
      end

      def items
        @@items
      end
    end
  end
end
