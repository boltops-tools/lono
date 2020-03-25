require 'cli-format'

class Lono::Extension
  class List
    def initialize(options={})
      @options = options
      @stack, @blueprint, @template, @param = Lono::Conventions.new(options).values
    end

    def run
      if @blueprint
        blueprint_configsets
      else
        project_configsets
      end
    end

    def blueprint_configsets
      Lono::Extensions::Preparer.new(@options).run # register and materialize gems
      tracked_extension_names = Lono::Jade::Registry.tracked_extensions.map(&:name)

      finder = Lono::Finder::Extension.new
      jadespecs = finder.find_all

      presenter = CliFormat::Presenter.new(@options)
      presenter.header = %w[Name Path Type]
      jadespecs.each do |j|
        if tracked_extension_names.include?(j.name)
          pretty_path = j.root.sub("#{Lono.root}/",'').sub(ENV["HOME"], "~")
          presenter.rows << [j.name, pretty_path, j.source_type]
        end
      end
      presenter.show
    end

    def project_configsets
      Lono::Finder::Extension.list(filter_materialized: true, message: "Project extensions:")
    end
  end
end
