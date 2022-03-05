class Lono::Files
  class Base < Lono::CLI::Base
    delegate :full_path, :output_path, :zip_name, :zip_path, to: :files
    attr_reader :files
    def initialize(options={})
      super
      # @files is reference to Lono::Files self instance
      # IE: Lono::Files instance is the caller
      @files = options[:files]
    end
  end
end
