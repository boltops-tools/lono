module Lono::Api
  module Repos
    def repos(type)
      res = http.get("repos?type=#{type}")
      load_json(res)
    end
  end
end
