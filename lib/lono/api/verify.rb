module Lono::Api
  module Verify
    def verify(data)
      res = http.post("verify", data)
      load_json(res)
    end

    def temp_key
      res = http.post("temp_keys")
      load_json(res)
    end
  end
end
