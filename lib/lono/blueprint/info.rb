# Small wrapper class to keep blueprint name and path.
# Found this to be a little cleaner than using a hash.
class Lono::Blueprint
  class Info
    attr_reader :name, :path
    def initialize(name, path)
      @name, @path = name, path
    end
  end
end
