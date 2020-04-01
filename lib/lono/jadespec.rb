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
      deprecation_check(metadata)
      metadata["lono_type"] || detect_type
    end

    def detect_type
      configset = Dir.glob("#{@root}/lib/configset.*").size > 0
      configset ? "configset" : "blueprint"
    end

    def lono_strategy
      deprecation_check(metadata)
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

  private
    @@deprecation_check_shown = {}
    def deprecation_check(metadata)
      return unless ENV['LONO_DEPRECATION_SOFT']
      return if @@deprecation_check_shown[name]

      unless metadata["lono_type"]
        puts "DEPRECATION WARNING: lono_type is not set for #{name}".color(:yellow)
      end
      unless metadata["lono_strategy"]
        puts "DEPRECATION WARNING: lono_strategy is not set for #{name}".color(:yellow)
      end
      @@deprecation_check_shown[name] = true
    end
  end
end
