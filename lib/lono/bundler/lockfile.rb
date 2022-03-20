require "yaml"

module Lono::Bundler
  class Lockfile
    include Singleton
    include LB::Util::Logging

    # [{"name"=>"vpc",
    #   "type"=>"blueprint",
    #   "sha"=>"52328b2b5197f9b95e3005cfcfb99595040ee45b",
    #   "source"=>"org/terraform-aws-vpc",
    #   "url"=>"https://github.com/org/terraform-aws-vpc"},
    #   {"name" => "instance",
    #   "type"=>"blueprint",
    #   "sha"=>"570cca3ea7b25e3af1961dc57b27ca2c129b934a",
    #   "source"=>"org/terraform-aws-instance",
    #   "url"=>"https://github.com/org/terraform-aws-instance"}]
    @@components = nil
    def components
      return @@components if @@components
      lockfile = LB.config.lockfile
      components = File.exist?(lockfile) ? YAML.load_file(lockfile) : []
      @@components = components.map do |props|
        Component.new(props)
      end
    end

    # update (if version mismatch) or create (if missing)
    def sync(component)
      replace!(component) if changed?(component)
    end

    # component built from Lonofile
    def changed?(component)
      # missing componentule case
      found = components.find { |locked_component| locked_component.name == component.name }
      unless found
        logger.debug "Replacing component: #{component.name}. Not found in Lonofile.lock"
        return true
      end

      comparer = VersionComparer.new(found, component)
      comparer.run
      logger.debug("REASON: #{comparer.reason}") if comparer.reason
      comparer.changed?
    end

    def replace!(component)
      # components are immediately fresh from writing to @@components directly
      @@components.delete_if { |c| c.name == component.name && c.type == component.type }
      @@components << component
      @@components.sort_by!(&:name)
    end

    def prune(removed_components)
      removals = removed_components.map(&:name)
      @@components.delete_if { |m| removals.include?(m.name) }
    end

    class << self
      def write
        Yamler.write(@@components) if @@components
      end
    end
  end
end
