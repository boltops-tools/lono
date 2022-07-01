require "aws_data"

# Layers example
#
#     app/blueprints/demo/config/params/base.txt
#     app/blueprints/demo/config/params/dev.txt
#     app/blueprints/demo/config/params/prod.txt
#     app/blueprints/demo/config/vars/base.rb
#     app/blueprints/demo/config/vars/dev.rb
#     app/blueprints/demo/config/vars/prod.rb
#
module Lono::Layering
  class Layer
    include Lono::Layering
    include Lono::Utils::Logging
    include Lono::Utils::Pretty
    include Lono::Concerns::AwsInfo
    extend Memoist

    def initialize(blueprint, type)
      @blueprint, @type = blueprint, type
    end

    def paths
      blueprint = full_layers("app/blueprints/#{@blueprint.name}/config")
      project = full_layers("config/blueprints/#{@blueprint.name}")
      paths = blueprint + project
      add_ext!(paths)
      paths.map! { |p| "#{Lono.root}/#{p}" }
      show_layers(paths)
      paths
    end

    def full_layers(dir)
      layers = layer_levels("#{dir}/#{@type}") # root
      if Lono.role
        layers += layer_levels("#{dir}/#{@type}/#{Lono.role}")
      end
      if Lono.app
        layers += layer_levels("#{dir}/#{@type}/#{Lono.app}")
      end
      if Lono.app && Lono.role
        layers += layer_levels("#{dir}/#{@type}/#{Lono.app}/#{Lono.role}")
      end
      layers
    end

    # adds prefix and to each layer pair that has base and Lono.env. IE:
    #
    #    "#{prefix}/base"
    #    "#{prefix}/#{Lono.env}"
    #
    # Params Layers:
    #     config/blueprints/demo/params/txt
    #     config/blueprints/demo/params/base.txt
    #     config/blueprints/demo/params/dev.txt
    def layer_levels(prefix=nil)
      levels = ["", "base", Lono.env]
      levels << "#{Lono.env}-#{Lono.extra}" if Lono.extra
      levels.map! do |i|
        [prefix, i].reject(&:blank?).join('/')
      end
      levels.map! { |level| level.sub(/\/$/,'') } # strip trailing slash

      # layers = pre_layers + main_layers + post_layers
      levels = layers.inject([]) do |sum, layer|
        layer_levels = levels.map do |level|
          [level, layer].reject(&:blank?).join('/')
        end
        sum += layer_levels
        sum
      end

      levels
    end

    # Interface method: layers = pre_layers + main_layers + post_layers
    # Simple layering is default. Can set with:
    #
    #      config.layering.mode = "simple" # simple or full
    #
    def main_layers
      if Lono.config.layering.mode == "simple"
        ['']
      else # full
        # includes region, account, and account/region layers
        # More powerful but less used and more complex to understand
        [
          '',
          region,
          account,
          "#{account}/#{region}",
        ]
      end
    end

    def add_ext!(paths)
      exts = {
        params: "env",
        vars: "rb",
      }
      ext = exts[@type.to_sym]

      paths.map! do |path|
        path = path.sub(/\/$/,'') if path.ends_with?('/')
        "#{path}.#{ext}"
      end
    end

    @@shown_layers = {}
    def show_layers(paths)
      return if @@shown_layers[@type]
      logger.debug "#{@type.capitalize} Layers:"
      show = Lono.config.layering.show || ENV['LONO_LAYERS']
      paths.each do |path|
        # next if path.include?("app/blueprints/") # more useful to show only config layers
        if ENV['LONO_LAYERS_ALL']
          logger.info "    #{pretty_path(path)}"
        elsif show
          logger.info "    #{pretty_path(path)}" if File.exist?(path)
        end
      end
      @@shown_layers[@type] = true
    end

    def account
      name = aws_data.account
      # friendly name mapping
      names = Lono.config.layering.names.stringify_keys
      names[name] || name
    end
  end
end
