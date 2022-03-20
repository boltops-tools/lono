# Delegates to:
#
#   1. Local
#   2. Git
#
class Lono::Bundler::Component
  class Fetcher
    def initialize(component)
      @component = component
    end

    def instance
      type = @component.source_type == "registry" ? "git" : @component.source_type
      klass = "Lono::Bundler::Component::Fetcher::#{type.camelize}".constantize
      klass.new(@component) # IE: Local.new(@component), Git.new(@component), S3.new(@component), etc
    end
  end
end
