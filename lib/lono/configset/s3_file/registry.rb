module Lono::Configset::S3File
  class Registry
    cattr_reader :items
    @@items = []

    class << self
      def register(name, options)
        @@items << Item.new(name, options) unless @@items.detect { |i| i.name == name }
      end
    end
  end
end
