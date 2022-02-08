module Lono
  class Importer < Lono::CLI::Base
    def run
      # Examples:
      #   Lono::Importer::Erb.new(source, options.clone).run
      #   Lono::Importer::Dsl.new(source, options.clone).run
      type = @options[:type] || 'dsl'
      importer_class = "Lono::Importer::#{type.classify}"
      importer_class = Object.const_get(importer_class)
      importer_class.new(@options).run
    end
  end
end
