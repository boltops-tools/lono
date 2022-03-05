module Lono::Builder::Dsl::Helpers
  module Files
    def files(path)
      Lono::Files.register(@options.merge(path: path))
    end
  end
end
