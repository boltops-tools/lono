require "text-table"

class Lono::Configset
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

    def project_configsets
      Lono::Finder::Configset.list(filter_materialized: true, message: "Project configsets:")
    end

    def blueprint_configsets
      Lono::Configset::Preparer.new(@options).run # register and materialize gems

      @final ||= []

      project = Lono::Configset::Register::Project.new(@options)
      project.register
      finder = Lono::Finder::Configset.new
      finder.list("Configsets available to project and can used with configs:") if @options[:verbose]
      puts "Configsets project is using for the #{@blueprint} blueprint:" if @options[:verbose]
      show(project.configsets, finder.find_all, "project")

      blueprint = Lono::Configset::Register::Blueprint.new(@options)
      blueprint.register
      finder = Lono::Finder::Blueprint::Configset.new
      finder.list("Configsets available to #{@blueprint} blueprint:") if @options[:verbose]
      puts "Configsets built into the blueprint:" if @options[:verbose]
      show(blueprint.configsets, finder.find_all, "blueprint")

      table = Text::Table.new
      table.head = ["Name", "Path", "Type", "From"]
      @final.each do |spec|
        pretty_root = spec.root.sub("#{Lono.root}/",'')
        table.rows << [spec.name, pretty_root, spec.source_type, spec.from]
      end

      if table.rows.empty?
        puts "No configsets being used."
      else
        puts "Configsets used by #{@blueprint.color(:green)} blueprint:"
        puts table
      end
    end

    def show(configsets, all, from)
      configsets.each do |c|
        puts "    #{c.name}" if @options[:verbose]
        spec = all.find { |jadespec| jadespec.name == c.name }
        next unless spec
        spec.from = from
        @final << spec
      end
      puts "" if @options[:verbose]
    end
  end
end
