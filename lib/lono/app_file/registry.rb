module Lono::AppFile
  class Registry
    cattr_reader :items
    @@items = []

    class << self
      def register(name, blueprint, options={})
        @@items << Item.new(name, blueprint, options) unless @@items.detect { |i| i.name == name && i.type == options[:type] }
      end

      def layers
        @@items.select { |i| i.type == "lambda_layer" }
      end
    end
  end
end
