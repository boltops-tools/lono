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

    def full_layering
      # layers defined in Lono::Layering module
      all = layers.map { |layer| layer.sub(/\/$/,'') } # strip trailing slash
      all.inject([]) do |sum, layer|
        sum += layer_levels(layer) unless layer.nil?
        sum
      end
    end

    # interface method
    def main_layers
      [
        '',
        region,
        account,
        "#{account}/#{region}",
      ]
    end

    def account
      name = aws_data.account
      # friendly name mapping
      names = Lono.config.layering.names.stringify_keys
      names[name] || name
    end

    # adds prefix and to each layer pair that has base and Lono.env. IE:
    #
    #    "#{prefix}/base"
    #    "#{prefix}/#{Lono.env}"
    #
    def layer_levels(prefix=nil)
      levels = ["base", Lono.env]
      levels.map! do |i|
        # base layer has prefix of '', reject with blank so it doesnt produce '//'
        [prefix, i].reject(&:blank?).join('/')
      end
      levels.unshift(prefix) # unless prefix.blank? # IE: params/us-west-2.txt
      levels
    end

    def add_ext!(paths)
      exts = {
        params: "txt",
        vars: "rb",
      }
      ext = exts[@type.to_sym]

      paths.map! do |path|
        path = path.sub(/\/$/,'') if path.ends_with?('/')
        "#{path}.#{ext}"
      end
    end

    def full_layers(dir)
      layers = full_layering.map do |layer|
        "#{dir}/#{@type}/#{layer}"
      end
      if Lono.app
        app_layers = full_layering.map do |layer|
          "#{dir}/#{@type}/#{Lono.app}/#{layer}"
        end
        layers += app_layers
      end
      layers
    end

    @@shown_layers = {}
    def show_layers(paths)
      return if @@shown_layers[@type]
      logger.debug "#{@type.capitalize} Layers:"
      paths.each do |path|
        logger.debug "    #{pretty_path(path)}" if File.exist?(path) || ENV['LONO_SHOW_ALL_LAYERS']
      end
      logger.debug ""
      @@shown_layers[@type] = true
    end
  end
end
