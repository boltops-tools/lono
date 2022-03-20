# Class name is Lono::Files because can represent a single file or a directory.
# Also, it avoids conflicting with the stdlib File class name.
# Files is like a "FileList". Using shorter Files name.
module Lono
  class Files < Lono::CLI::Base
    include Concerns::Registration
    include Concerns::PostProcessing

    attr_reader :path, :layer, :type
    def initialize(options={})
      super
      @path = options[:path]
      @layer = options[:layer]
      @type = @layer ? "layer" : "normal"
      @caller = options[:caller] # original caller stack at registration time
    end

    def full_path
      "#{@blueprint.root}/#{@path}"
    end

    class << self
      def register(options={})
        path = options[:path]
        layer = options[:layer]
        # Registration uniquess based on both path and layer option
        file = files.find { |f| f.path == path && f.layer == layer }
        unless file
          file = Files.new(options.merge(caller: caller))
          files << file
        end
        file.marker
      end

      delegate :empty?, :files, to: :files
      def files
        Registry.files
      end
    end
  end
end
