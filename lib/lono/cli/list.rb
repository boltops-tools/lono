class Lono::CLI
  class List < Base
    attr_reader :options
    def initialize(options={})
      @options = options
    end

    def run
      list_type("blueprints") if show?("blueprint")
      list_type("configsets") if show?("configset")
      list_type("extensions") if show?("extension")
    end

  private
    def list_type(type)
      lookup.list(type)
    end

    def lookup
      Lono::Lookup.new
    end
    memoize :lookup

    def show?(type)
      @options[:type] == type || @options[:type].nil? || @options[:type] == "all"
    end
  end
end
