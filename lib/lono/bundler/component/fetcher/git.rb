class Lono::Bundler::Component::Fetcher
  class Git < Base
    extend Memoist

    def run
      setup_tmp
      org_folder = cache_path(@component.org_folder)
      FileUtils.mkdir_p(org_folder)

      Dir.chdir(org_folder) do
        logger.debug "Current root dir: #{org_folder}"
        clone unless File.exist?(@component.repo)

        Dir.chdir(@component.repo) do
          logger.debug "Change dir: #{@component.repo}"
          git "pull"
          git "submodule update --init"
          stage
        end
      end
    end
    memoize :run

    def clone
      command = ["git clone", ENV['LB_GIT_CLONE_ARGS'], @component.url].compact.join(' ')
      sh command
    rescue LB::GitError => e
      logger.error "ERROR: #{e.message}".color(:red)
      exit 1
    end

    def stage
      copy_to_stage
      checkout = @component.checkout_version || default_branch
      switch_version(checkout)
    end

    # Note: if not in a git repo, will get this error message in stderr
    #
    #    fatal: Not a git repository (or any of the parent directories): .git
    #
    def default_branch
      origin = `git remote show origin`.strip
      found = origin.split("\n").find { |l| l.include?("HEAD") }
      if found
        found.split(':').last.strip
      else
        ENV['TS_GIT_DEFAULT_BRANCH'] || 'master'
      end
    end

    def switch_version(version)
      stage_path = stage_path(rel_dest_dir)
      logger.debug "stage_path #{stage_path}"
      Dir.chdir(stage_path) do
        git "checkout #{version}"
        @sha = git("rev-parse HEAD").strip
      end
    end

    def copy_to_stage
      cache_path = cache_path(rel_dest_dir)
      stage_path = stage_path(rel_dest_dir)
      FileUtils.rm_rf(stage_path)
      FileUtils.mkdir_p(File.dirname(stage_path))
      FileUtils.cp_r(cache_path, stage_path)
    end
  end
end
