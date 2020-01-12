class Lono::Template::Strategy::Dsl::Builder
  module Stringify
    # Accounts for Arrays also. ActiveSupport only works for Hashes.
    def stringify!(data)
      case data
      when Array
        data.map! { |i| stringify!(i) }
      when Hash
        data.deep_transform_keys! { |k| k.to_s }
      else
        data # do not transform
      end
    end
  end
end
