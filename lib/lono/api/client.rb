module Lono::Api
  class Client
    extend Memoist
    include Verify
    include Repos

    def http
      Proxy.new
    end
    memoize :http

    def load_json(res)
      if res.code == "200"
        data = JSON.load(res.body)
        case data
        when Array
          data.map(&:deep_symbolize_keys)
        when Hash
          data.deep_symbolize_keys
        end
      else
        if ENV['LONO_DEBUG_API']
          puts "Error: Non-successful http response status code: #{res.code}"
          puts "headers: #{res.each_header.to_h.inspect}"
        end
        nil
      end
    end
  end
end
