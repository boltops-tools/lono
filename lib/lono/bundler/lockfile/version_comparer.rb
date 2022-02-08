class Lono::Bundler::Lockfile
  class VersionComparer
    attr_reader :reason, :changed
    def initialize(locked, current)
      @locked, @current = locked, current
      @changed = false
    end

    def changed?
      @changed
    end

    # Tricky logic, maybe spec this.
    #
    #   no components specified:
    #     lono bundle update  # no components specified => update all
    #     lono bundle install # no Lonofile.lock => update all
    #   components specified:
    #     lono bundle update s3  # explicit component => update s3
    #     lono bundle install s3 # errors: not possible to specify componentule for install command
    #
    # Note: Install with specific components wipes existing components. Not worth it to support.
    #
    def run
      @changed = false

      # Most props are "strict" version checks. So if user changes options generally in the component line
      # the Lonofile.lock will get updated, which is expected behavior.
      props = @locked.props.keys + @current.props.keys
      strict_versions = props.uniq.sort - [:sha, :type]
      strict_versions.each do |version|
        @changed = @locked.send(version) != @current.send(version)
        if @changed
          @reason = reason_message(version)
          return @changed
        end
      end

      # Lots of nuance with the sha check that works differently
      # Only check when set.
      # Also in update mode then always check it.
      @changed = @current.sha && !@locked.sha.include?(@current.sha) ||
                 LB.update_mode? && !@current.latest_sha.include?(@locked.sha)
      if @changed
        @reason = reason_message("sha")
        return @changed
      end

      @changed
    end

    def reason_message(version)
      "Replacing component #{@current.name} because #{version} is different in Lonofile and Lonofile.lock"
    end
  end
end
