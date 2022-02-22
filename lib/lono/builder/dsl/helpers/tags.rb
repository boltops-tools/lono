module Lono::Builder::Dsl::Helpers
  module Tags
    def tags(hash={})
      if hash.empty?
        tag_list(@tags) if @tags # when hash is empty, use @tags variable. If not set then return nil
      else
        tag_list(hash)
      end
    end

    def tag_list(hash)
      raise "tags hash cannot be empty" if hash == nil

      if hash.is_a?(Array)
        hash = hash.inject({}) do |h,i|
          i.symbolize_keys!
          h[i[:Key]] = i[:Value]
          h
        end
        return tag_list(hash) # recursive call tag_list to normalized the argument with a Hash
      end

      propagate = hash[:PropagateAtLaunch] # special treatment
      list = hash.map do |k,v|
        h = {Key: k.to_s, Value: v}
        h[:PropagateAtLaunch] = propagate unless propagate.nil?
        h
      end
      list.reject { |h| h[:Key] == "PropagateAtLaunch" }
    end

    def dimensions(hash)
      tag_list(hash).map { |h|
        h[:Name] = h.delete(:Key) || h.delete(:key)
        h
      }
    end
  end
end
