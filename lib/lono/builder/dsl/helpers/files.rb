module Lono::Builder::Dsl::Helpers
  module Files
    def files(path, o={})
      Lono::Files.register(@options.merge(path: path).merge(o))
    end
  end
end
