# Interface of subclasses should implement
#
#   run
#   switch_version(component.sha)
#   sha
#
class Lono::Bundler::Component::Fetcher
  class Base
    include LB::Util::Git
    include LB::Util::Logging
    include LB::Component::Concerns::PathConcern

    attr_reader :sha # returns nil for Local
    def initialize(component)
      @component = component
    end

    def switch_version(*)
      # noop
    end

    def extract(archive, dest)
      Lono::Bundler::Extract.extract(archive, dest)
    end

  end
end
