module Lono
  class Stringer
    def self.transform(data)
      case data
      when Array
        data.map! { |i| transform(i) }
      when Hash
        data.deep_transform_keys! { |k| k.to_s }
      else
        data # do not transform
      end
    end
  end
end
