require "yaml"

class Lono::Blueprint
  class Find
    class << self
      extend Memoist

      def one_or_all(blueprint)
        blueprint ? [blueprint] : all_blueprints
      end

      # Returns both project and gem blueprints
      def all_blueprints
        project_blueprints = all_project_blueprint_infos.map { |info| info.name }

        gem_blueprints = specs.map do |spec|
          dot_lono = dot_lono_path(spec)
          config = YAML.load_file(dot_lono)
          config["blueprint_name"]
        end

        all = project_blueprints + gem_blueprints
        all.uniq
      end

      # Returns blueprint root full path. Can be:
      #
      #   1. projects blueprints/BLUEPRINT - higher precedence
      #   2. full gem path
      #
      def find(blueprint)
        # Check projects blueprints
        info = all_project_blueprint_infos.find { |info| info.name == blueprint}
        return info.path if info

        # Check gem specs
        result = specs.find do |spec|
          dot_lono = dot_lono_path(spec)
          config = YAML.load_file(dot_lono)
          config["blueprint_name"] == blueprint
        end
        result.full_gem_path if result
      end

      # Returns: Array of Blueprint::Info. Example:
      #
      #   [#<Lono::Blueprint::Info:0x0000561e620e0548
      #     @name="ecs-spot-fleet",
      #     @path="/full/path/to/blueprint/ecs-spot-demo">,
      #   #<Lono::Blueprint::Info:0x0000561e61e132c0
      #     @name="ec2",
      #     @path="/full/path/to/blueprint/ec2">]
      def all_project_blueprint_infos
        infos = []
        Dir.glob("#{Lono.root}/blueprints/*").select do |p|
          dot_lono = dot_lono_path(p)
          next unless File.exist?(dot_lono)
          config = YAML.load_file(dot_lono)
          infos << Info.new(config["blueprint_name"], p)
        end
        infos
      end

      # Only the blueprint specs
      def specs
        specs = Bundler.load.specs
        specs.select do |spec|
          File.exist?(dot_lono_path(spec))
        end
      end
      memoize :specs

      def dot_lono_path(source)
        if source.is_a?(String) # path to folder
          "#{source}/.lono/config.yml"
        else # spec
          "#{source.full_gem_path}/.lono/config.yml"
        end
      end

      def bundler_version_check!
        return unless Bundler.bundler_major_version >= 1 # LockfileParser only works for Bundler version 2+

        puts "ERROR: The bundler version detected is too old. Please use bundler 2+".color(:red)
        puts "Current detected bundler version is #{Bundler.bundler_major_version}"
        exit 1
      end
    end
  end
end
