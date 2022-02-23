module Lono::Builder::Dsl::Syntax::Core
  class Squeezer
    def initialize(data)
      @data = data
    end

    def squeeze(new_data=nil, previous_key=nil)
      data = new_data.nil? ? @data : new_data

      case data
      when Array
        data.map! { |v| squeeze(v) }
      when Hash
        data.each_with_object({}) do |(k,v), squeezed|
          # only remove nil and empty Array values within Hash structures
          squeezed[k] = squeeze(v, k) unless v.nil? # || empty_array?(v, previous_key)
          squeezed
        end
      else
        data # do not transform
      end
    end

    # Special case do not squeeze empty Array when previous_key is "yum". Handles:
    #
    #   Metadata:
    #     AWS::CloudFormation::Init:
    #       config:
    #         packages:
    #           yum:
    #             httpd: []
    #
    def empty_array?(v, previous_key)
      return false if previous_key.to_s == "yum"
      v.is_a?(Array) && v.empty?
    end
  end
end
