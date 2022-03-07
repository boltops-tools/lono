class Lono::Builder::Configset::Definition
  module Context
    include DslEvaluator

    def load_context
      load_vars
      load_helpers
    end

    # Docs: https://lono.cloud/docs/configsets/layering/
    # Think layering is simple enough to keep in this method for now.
    # Consider trying to combine with Lono::Layering::Layer for uniformity though.
    def load_vars
      layers.each do |layer|
        evaluate_file(layer)
      end
    end

    def layers
      paths = [
        "#{@configset.root}/vars.rb", # source defaults
        "#{Lono.root}/config/configsets/#{@configset.name}/vars.rb", # source overrides
        "#{@blueprint.root}/config/configsets/vars/#{@configset.name}.rb", # blueprint overrides
        "#{Lono.root}/config/blueprints/#{@blueprint.name}/configsets/vars/#{@configset.name}.rb", # user overrides
      ]
      show_layers(paths)
      paths
    end

    def show_layers(paths)
      if ENV['LONO_LAYERS_ALL']
        show_all_layers(paths)
      else
        show_existing_layers(paths)
      end
    end

    def show_all_layers(paths)
      show_header
      paths.each do |path|
        show_layer(path)
      end
    end

    def show_existing_layers(paths)
      existing = paths.select { |path| File.exist?(path) }
      return if existing.empty?
      show_header
      existing.each do |path|
        show_layer(path)
      end
    end

    def show_header
      logger.info "    Configset Layers #{@configset.name}"
    end

    def show_layer(path)
      logger.info "        #{pretty_path(path)}"
    end

    def show_layers?
      Lono.config.layering.show || ENV['LONO_LAYERS']
    end

    def load_helpers
      load_helper_files("#{@configset.root}/helpers", type: :configset)
    end
  end
end
