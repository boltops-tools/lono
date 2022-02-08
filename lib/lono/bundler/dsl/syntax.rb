class Lono::Bundler::Dsl
  module Syntax
    def org(value)
      config.org = value
    end
    alias_method :user, :org

    def base_clone_url(value)
      config.base_clone_url = value
    end

    def export_to(path)
      config.export_to = path
    end

    def export_purge(value)
      config.export_purge = value
    end

    def stack_options(value={})
      config.stack_options.merge!(value)
    end

    def clone_with(value)
      config.clone_with = value
    end

    def config
      LB.config
    end

    def component(name, options={})
      meta[:components] << options.merge(name: name)
    end

    def self.friendly_method(meth)
      define_method meth do |name, options={}|
        component(name, options.merge(type: meth.to_s))
      end
    end

    friendly_method :blueprint
    friendly_method :configset
    friendly_method :extension
  end
end
