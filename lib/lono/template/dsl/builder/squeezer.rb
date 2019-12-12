# Based on https://stackoverflow.com/questions/32174183/remove-nil-values-from-hash
class Lono::Template::Dsl::Builder
  class Squeezer
    def initialize(data)
      @data = data
    end

    def squeeze(new_data=nil)
      data = new_data || @data
      data.each_with_object({}) do |(k, v), squeezed|
        if v.is_a?(Array)
          squeezed[k] = v.map { |i| squeeze(i) }
        elsif v.is_a?(Hash)
          squeezed[k] = squeeze(v)
        else
          squeezed[k] = v unless v.nil?
        end
        squeezed
      end
    end
  end
end
