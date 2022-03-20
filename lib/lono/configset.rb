module Lono
  class Configset < Component
    attr_reader :resource
    attr_accessor :metadata
    def initialize(options={})
      super
      @resource = options[:resource]
    end

    def path
      return unless root
      exts = %w[rb yml json] # rb highest precedence
      paths = exts.map { |ext| "#{root}/configset.#{ext}" }
      paths.find { |p| File.exist?(p) }
    end
  end
end
