module Lono::Configset::Materializer
  class Source
    def initialize(lono_settings=nil)
      @lono_settings = lono_settings || Lono::Setting.new.data
    end

    # String provide to gem method in Gemfile.  Example:
    #
    #      gem "mygem", "v0.1.0", git: "xxx"
    #
    def gem_args(jade)
      args = jade.registry.args
      args = args.map { |s| %Q|"#{s}"| }.join(', ')

      options = options(jade)
      options = options.inject([]) { |r,(k,v)| r << %Q|#{k}: "#{v}"| }.join(', ')

      "#{args}, #{options}"
    end

    def options(jade)
      registry = jade.registry
      options = registry.gem_options
      # Direct source provided as part of configset call
      #
      #    configset("ssm", git: "https://github.com/owner/ssm")
      #    configset("ssm", path: "/path/to/ssm")
      #    configset("ssm", source: "https://rubygems.org")
      #
      if options.key?(:git) || options.key?(:path) || options.key?(:source)
        return(options)
      end

      # Otherwise use the sources location settings, which does not include the repo name
      materalized_options = if location.include?("git@") || location.include?("https")
        {git: "#{location}/#{jade.repo}"}
      else
        {path: "#{location}/#{jade.repo}"}
      end
      materalized_options.merge(options)
    end

    def location
      ENV["LONO_MATERIALIZED_GEMS_SOURCE"] ||
      Lono::Configset::Register::Blueprint.source ||
      settings["source"] ||
      "git@github.com:boltopspro" # default_location
    end

    def settings
      @lono_settings.dig("materialized_gems") || {}
    end
  end
end
