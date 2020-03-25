require "rubygems"

module Lono
  class Jadespec
    extend Memoist

    attr_accessor :from
    attr_reader :root, :source_type
    def initialize(root, source_type)
      @root, @source_type = root, source_type
    end

    def name
      exist? ? gemspec.name : "not gemspec file found for @root: #{@root}"
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

    def lono_type
      metadata["lono_type"] || detect_type
    end

    def detect_type
      configset = Dir.glob("#{@root}/lib/configset.*").size > 0
      configset ? "configset" : "blueprint"
    end

    def lono_strategy
      return metadata["lono_strategy"] if metadata["lono_strategy"]
      lono_type == "blueprint" ? "dsl" : "erb" # TODO: default to dsl for configset also in next major release
    end

    # backward-compatiable for now
    def auto_camelize
      metadata["lono_auto_camelize"] || false
    end

    def metadata
      gemspec.metadata || {}
    end
    memoize :metadata
  end
end
