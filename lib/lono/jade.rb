module Lono
  class Jade
    include Circular
    extend Memoist

    delegate :source_type, to: :jadespec

    attr_accessor :dependencies, :from, :depends_ons
    attr_reader :name, :type, :registry, :jadespec
    def initialize(name, type, registry={})
      # type: one of blueprint, configset, blueprint/configset
      # registry holds either original registry from configset definition or parent jade which can be used to get the original configset defintion
      @name, @type, @registry = name, type, registry
      @materialized = false
      @resolved = false
      @depends_ons = []
    end

    def repo
      @registry.options[:repo] || @name
    end

    # root is kind of special. root is needed for materialization but can accidentally get called too early
    # before materialization. So treat it specially with an error.
    def root
      raise "ERROR: root is not available until jade has been materialized" unless @jadespec
      @jadespec.root
    end

    def dependencies
      @depends_ons.map do |registry|
        jade = Lono::Jade.new(registry.depends_on, registry.parent.type, registry) # not same sig as register_configset?
        Lono::Jade::Registry.tracked_configsets << jade
        jade
      end
    end

    def resource_from_parent
      parent = registry.parent # using local variable intentionally
      resource = nil
      while parent # go all the way to the highest parent
        resource = parent.registry.resource
        parent = parent.registry.parent
      end
      resource
    end

    def materialize
      @jadespec = finder.find(@name)
      download unless @jadespec
      # Pretty tricky. Flush memoized finder(true) since download changes filesystem. Not memoizing at all is 2x slower
      @jadespec = finder(true).find(@name)
      return nil unless @jadespec
      if @jadespec.source_type == "materialized"
        # possible "duplicated" jade instances with same name but will uniq in final materialized Gemfile
        case @jadespec.lono_type
        when "configset"
          Lono::Jade::Registry.downloaded_configsets << self
        when "extension"
          Lono::Jade::Registry.downloaded_extensions << self
        end
      end
      evaluate_meta_rb
      @jadespec
    end
    memoize :materialize

    # Must return config to set @jadespec in materialize
    # Only allow download of Lono::Blueprint::Configset::Jade
    # Other configsets should be configured in project Gemfile.
    #
    # Cases:
    #
    #    1a) blueprint/configset top-level - download
    #    1b) blueprint/configset depends_on - download
    #    2a) configset top-level - dont download, will report to user with validate_all!
    #    2b) configset depends_on - download
    #    3) extension - download
    #
    def download
      return if finder.find(@name, local_only: true) # no need to download because locally found
      return unless %w[blueprint/configset configset extension].include?(@type)
      # Comment out. Unsure if this complexity is worth it. Always download jades.
      # Only download jades that came from depends_on
      # return unless @registry.parent || %w[blueprint/configset extension].include?(@type)
      materializer = Materializer.new(self)
      materializer.build
    end
    memoize :download

    def evaluate_meta_rb
      return unless %w[blueprint/configset configset].include?(@type)
      meta = Lono::Configset::Meta.new(self)
      meta.evaluate
    end

    def resolved!
      @resolved = true
    end

    def resolved?
      @resolved
    end

    def finder
      "Lono::Finder::#{@type.camelize}".constantize.new
    end
    memoize :finder
  end
end
