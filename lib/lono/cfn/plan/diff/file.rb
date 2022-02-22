module Lono::Cfn::Plan::Diff
  class File < Base
    def show(existing_path, new_path)
      if @options[:mode] == true || @options[:mode] == "summary"
        summary(existing_path, new_path)
      else # full
        full(existing_path, new_path)
      end
    end

    def summary(existing_path, new_path)
      command = "diff #{existing_path} #{new_path} -u -s"
      # actually use diff but show colordiff in pretty_command
      pretty_command = "#{diff_viewer} #{pretty_path(existing_path)} #{pretty_path(new_path)}"
      logger.info "=> #{pretty_command}"
      out = `#{command}`
      lines = out.split("\n")
      lines.reject! { |l| l =~ /^\+\+\+ / || l =~ /^--- / } # remove header lines
      stats = lines.inject(Hash.new(0)) do |stats,line|
        char = line[0] # first char will be - +
        case char
        when '+'
          stats[:insertions] += 1
        when '-'
          stats[:deletions] += 1
        end
        stats
      end
      if stats.all? { |_,count| count == 0 }
        logger.info "No changes"
      else
        logger.info "    #{stats[:insertions]} insertions(+), #{stats[:deletions]} deletions(-)"
      end
    end

    def full(existing_path, new_path)
      command = "#{diff_viewer} #{existing_path} #{new_path}"
      pretty_command = "#{diff_viewer} #{pretty_path(existing_path)} #{pretty_path(new_path)}"
      logger.info "=> #{pretty_command}"
      out = `#{command}`
      if out.strip == ''
        logger.info "No changes"
      else
        logger.info out
      end
    end

    def diff_viewer
      return ENV['LONO_DIFF'] if ENV['LONO_DIFF']
      colordiff_installed = system("type colordiff > /dev/null 2>&1")
      unless colordiff_installed
        logger.info "INFO: colordiff it not available. Recommend installing it."
      end
      colordiff_installed ? "colordiff" : "diff"
    end
  end
end
