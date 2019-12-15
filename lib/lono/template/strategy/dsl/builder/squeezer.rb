class Lono::Template::Strategy::Dsl::Builder
  class Squeezer
    def initialize(data)
      @data = data
    end

    def squeeze(new_data=nil)
      data = new_data.nil? ? @data : new_data

      case data
      when Array
        data.map! { |v| squeeze(v) }
      when Hash
        data.each_with_object({}) do |(k,v), squeezed|
          squeezed[k] = squeeze(v) unless v.nil? # only remove nil values within Hash structures
          squeezed
        end
      else
        data # do not transform
      end
    end
  end
end
