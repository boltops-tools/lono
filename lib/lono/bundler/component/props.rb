# Use to build component from Lonofile entry.
# The Lonofile.lock does not need this because it's simple and just merges the data.
class Lono::Bundler::Component
  class Props
    extend Memoist
    include Concerns::NotationConcern
    include LB::Util::Logging

    delegate :source_type, to: :typer

    attr_reader :source
    def initialize(options={})
      @options = options
      @source, @version = @options[:source], @options[:version]
    end

    def name
      remove_notations(@options[:name])
    end

    def build
      unless @source
        logger.error "ERROR: The source option must be set for the #{name} component in the Lonofile".color(:red)
        exit 1
      end
      o = @options.merge(
        name: name,
        source_type: source_type,
        url: url,
      )
      o[:subfolder] ||= subfolder(@source)
      o[:ref] ||= ref(@source)
      o.deep_symbolize_keys
    end

    # url is normalized
    def url
      url = case source_type
            when 'registry'
              registry.github_url
            when 'local'
              source
            when 'http'
              http_source_url
            else # git
              git_source_url
            end
      remove_notations(clone_with(url))
    end

    # apply clone_with option if set
    def clone_with(url)
      with = @options[:clone_with] || LB.config.clone_with
      return url unless with
      if with == 'https'
        url.sub(/.*@(.*):/,'https://\1/')
      else # git@
        url.sub(%r{http[s]?://(.*?)/},'git@\1:')
      end
    end

    def http_source_url
      source = Http::Source.new(@params)
      source.url
    end

    # git_source_url is normalized
    #
    # See: https://stackoverflow.com/questions/6167905/git-clone-through-ssh
    #
    #    ssh://username@host.xz/absolute/path/to/repo.git/ - just a forward slash for absolute path on server
    #    username@host.xz:relative/path/to/repo.git/ - just a colon (it mustn't have the ssh:// for relative path on server (relative to home dir of username on server machine)
    #
    # When colon is separator for relative path do not want ssh prepended
    #
    #   git clone ec2-user@localhost:repo
    #
    # When slash is separator for absolute path want ssh prepended
    #
    #   git clone ssh://ec2-user@localhost/path/to/repo => valid URI
    #
    def git_source_url
      if @source.include?('http') || @source.include?(':')
        # Examples:
        #   component "pet1", source: "https://github.com/tongueroo/pet"
        #   component "pet2", source: "git@github.com:tongueroo/pet"
        #   component "pet3", source: "git@gitlab.com:tongueroo/pet"
        #   component "pet4", source: "git@bitbucket.org:tongueroo/pet"
        #   component "example3", source: "git::https://example.com/example-module.git"
        #
        # sub to allow for generic git repo notiation
        source = @source.sub('git::','')
        if source.include?('ssh://')
          if source.count(':') == 1
            return source
          else
            return source.sub('ssh://', '')
          end
        end
        source
      else
        # Examples:
        #   component "pet", source: "tongueroo/pet"
        # Or:
        #   org "tongueroo"
        #   component "pet", source: "pet"
        org_source = @source.include?('/') ? @source : "#{LB.config.org}/#{@source}" # adds inferred org
        "#{LB.config.base_clone_url}#{org_source}"
      end
    end

    def typer
      Typer.new(self)
    end
    memoize :typer

    def registry
      Registry.new(@source, @version)
    end
    memoize :registry
  end
end
