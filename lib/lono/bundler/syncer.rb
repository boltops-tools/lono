module Lono::Bundler
  class Syncer
    include LB::Util::Logging

    def initialize(options={})
      @options = options
      @component = @options[:component]
    end

    def run
      validate!
      FileUtils.rm_f(LB.config.lockfile) if update_all?
      logger.info "Bundling with #{LB.config.lonofile}..."
      if File.exist?(LB.config.lockfile)
        sync
      else
        create
      end
      LB::Lockfile.write
    end

    def sync
      sync_components
      removal_components = subtract(lockfile.components, lonofile.components)
      lockfile.prune(removal_components)
    end

    def create
      sync_components
    end

    def sync_components
      # VersionComparer is used in lockfile.sync and does heavy lifting to check if component should be updated and replaced
      lonofile.components.each do |component|
        next unless sync?(component)
        logger.debug "Syncing #{component.name}"
        lockfile.sync(component) # update (if version mismatch) or create (if missing)
      end
    end

    def sync?(component)
      names = @options[:components]
      names.blank? or names.include?(component.name)
    end

    def validate!
      return unless lonofile.missing_org?
      logger.error "ERROR: org must be set in the #{LB.config.lonofile}.".color(:red)
      logger.error "Please set org in the Lonofile"
      exit 1
    end

    def update_all?
      LB.update_mode? && @options[:components].empty?
    end

    def subtract(components1, components2)
      component2_names = components2.map(&:name)
      components1.select { |component1| !component2_names.include?(component1.name) }
    end

    def lonofile
      Lonofile.instance
    end

    def lockfile
      Lockfile.instance
    end
  end
end
