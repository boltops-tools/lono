require "yaml"

class Lono::Bundler::Lockfile
  class Yamler
    def initialize(components)
      @components = components.sort_by(&:name)
    end

    def dump
      YAML.dump(data)
    end

    def data
      @components.map do |component|
        item(component)
      end
    end

    def item(component)
      props = component.props.dup # passthrough: name, url, version, ref, tag, branch etc
      props[:sha] ||= component.latest_sha
      props.delete_if { |k,v| v.nil? }
      props.deep_stringify_keys
    end

    def write
      IO.write(LB.config.lockfile, dump)
    end

    class << self
      def write(components)
        new(components).write
      end
    end
  end
end
