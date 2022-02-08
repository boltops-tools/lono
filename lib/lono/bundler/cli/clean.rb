class Lono::Bundler::CLI
  class Clean < Base
    include LB::Component::Concerns::PathConcern

    def run
      paths = [tmp_root]
      are_you_sure?(paths)
      paths.each do |path|
        FileUtils.rm_rf(path)
        logger.info "Removed #{path}"
      end

    end

    def are_you_sure?(paths)
      pretty_paths = paths.map { |p| "    #{p}" }.join("\n")
      message = <<~EOL.chomp
        Will remove these folders and all their files:

        #{pretty_paths}

        Are you sure?
      EOL
      sure?(message) # from Util::Sure
    end
  end
end
