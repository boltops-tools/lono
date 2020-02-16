require "rubygems"

module Lono
  class Jadespec
    extend Memoist

    delegate :name, to: :gemspec

    attr_accessor :from
    attr_reader :root, :source_type
    def initialize(root, source_type)
      @root, @source_type = root, source_type
    end

    def exist?
      !!gemspec_file
    end

    def gemspec
      Gem::Specification::load(gemspec_file)
    end
    memoize :gemspec

    def gemspec_file
      Dir.glob("#{@root}/*.gemspec").first
    end

    def type
      metadata["lono_type"] || "dsl"
    end
    alias_method :template_type, :type

    def strategy
      metadata["lono_strategy"] || "erb" # erb for now, will depreciate though
    end

    def auto_camelize
      metadata["lono_auto_camelize"] || false
    end

    def metadata
      gemspec.metadata || {}
    end
    memoize :metadata
  end
end
