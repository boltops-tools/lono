class Lono::Plugin
  module Meta
    extend ActiveSupport::Concern

    included do
      cattr_accessor :meta, default: []
    end

    class_methods do
      def register(o={})
        found = meta.find { |m| m[:name] == o[:name] && m[:type] == o[:type] }
        meta << o unless found
      end

      def find(o={})
        found = meta.find { |m| m[:name] == o[:name] && m[:type] == o[:type] }
        Lono::Plugin.new(found) if found
      end

      def delegate_to_meta(*attrs)
        attrs.each do |attr|
          attr = attr.to_sym
          define_method attr do
            @options[attr]
          end
        end
      end
    end
  end
end
