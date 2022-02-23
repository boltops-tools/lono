class Lono::Builder::Configset::Definition
  module Context
    include DslEvaluator

    def load_context
      load_vars
      load_helpers
    end

    # Docs: https://lono.cloud/docs/configsets/layering/
    # Layering is simple enough to keep in this method.
    def load_vars
      logger.debug "Layers for configset #{@configset.name}:"
      evaluate_layer("#{@configset.root}/vars.rb") # source defaults
      evaluate_layer("#{Lono.root}/config/configsets/#{@configset.name}/vars.rb") # source overrides
      evaluate_layer("#{@blueprint.root}/config/configsets/vars/#{@configset.name}.rb") # blueprint overrides
      evaluate_layer("#{Lono.root}/config/blueprints/#{@blueprint.name}/configsets/vars/#{@configset.name}.rb") # user overrides
    end

    def evaluate_layer(path)
      logger.debug "    #{pretty_path(path)}" if File.exist?(path) || ENV['LONO_SHOW_ALL_LAYERS']
      evaluate_file(path)
    end

    def load_helpers
      load_helper_files("#{@configset.root}/helpers", type: :configset)
    end
  end
end
