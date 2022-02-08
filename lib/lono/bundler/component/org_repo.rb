class Lono::Bundler::Component
  class OrgRepo
    def initialize(url)
      @url = url.sub('ssh://','') # important to copy so dont change the string reference
    end

    def repo
      org_repo_words[-1]
    end

    def org
      s = org_folder.split('/').last
      s ? s.split('/').last : 'none'
    end

    def org_folder
      org_repo_words[-2] # second to last word
    end

    def repo_folder
      org_repo_words.join('/')
    end

    def org_repo_words
      if @url.include?(':') && !@url.match(%r{http[s?]://}) # user@host:repo git@github.com:org/repo
        folder, repo = handle_string_with_colon
      else # IE: https://github.com/org/repo, org/repo, etc
        parts = @url.split('/')
        folder = parts[0..-2].join('/')
        repo = parts.last
      end

      org_path = clean_folder(folder)
      repo = strip_dot_git(repo)
      [org_path, repo]
    end

    def clean_folder(folder)
      folder.sub(%r{.*@},'')           # remove user@
            .sub(%r{http[s?]://},'')   # remove https://
    end

    # user@host:repo git@github.com:org/repo
    def handle_string_with_colon
      host, path = @url.split(':')
      if path.size == 2
        folder, repo = path.split(':')
      else
        folder = join(host, File.dirname(path))
        repo = File.basename(path)
      end
      [folder, repo]
    end

    def join(*path)
      path.compact!
      path[1] = path[1].sub('/','') if path[1].starts_with?('/')
      path.reject(&:blank?).join('/')
    end

    def strip_dot_git(s)
      s.sub(/\.git$/,'')
    end
  end
end
