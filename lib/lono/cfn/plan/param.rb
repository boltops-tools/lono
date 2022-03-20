class Lono::Cfn::Plan
  class Param < Base
    def run
      return unless Lono.config.plan.params && stack_exists?(@stack)
      logger.info "Parameter Changes:".color(:green)
      write_to_tmp(existing_path, existing_params)
      write_to_tmp(new_path, new_params)
      logger.debug "=> diff #{pretty_path(existing_path)} #{pretty_path(new_path)}"
      diff = Diff::Data.new(json_load(existing_path), json_load(new_path))
      diff.show
      logger.info "" # newline
    end

    def existing_params
      existing = stack_parameters
      params = normalize(existing)
      subtract(params, noecho_params)
    end
    memoize :existing_params

    def new_params
      parameters = @build.parameters
      params = normalize(parameters)
      params = optional_params.merge(params)
      params = replace_noecho_values!(params)
      subtract(params, noecho_params)
    end

    def replace_noecho_values!(params)
      template_output.parameters.each do |key, data|
        params[key] = '**** (NoEcho)' if data['NoEcho'] # mimic noecho
      end
      params
    end

    # Remove existing items with the same key. The value can be different. This removes the noecho params.
    def subtract(h1,h2)
      hash = h1.reject do |k,v|
        h2.keys.include?(k)
      end
      Hash[hash.sort_by {|k,v| k}]
    end

    def optional_params
      # normalizing to simple Hash
      template_output.optional_parameters.inject({}) do |result,(k,v)|
        result.merge(k => v["Default"].to_s)
      end
    end

    def noecho_params
      noecho = stack_parameters.select { |p| p.parameter_value == '****' }
      normalize(noecho)
    end
    memoize :noecho_params

    def stack_parameters
      resp = cfn.describe_stacks(stack_name: @stack)
      stack = resp.stacks.first
      stack.parameters
    end
    memoize :stack_parameters

  private
    def write_to_tmp(path, hash)
      text = JSON.pretty_generate(hash)
      FileUtils.mkdir_p(File.dirname(path))
      IO.write(path, text)
    end


    # Returns simple Hash. Example:
    #
    #     {"foo"=>"1", "bar"=>"2"},
    #
    def normalize(list)
      camelized = list.map(&:to_h).map do |h|
        h.transform_keys {|k| k.to_s.camelize}
      end
      camelized.sort_by! { |h| h["ParameterKey"] }
      camelized.inject({}) do |result,h|
        result.merge(h["ParameterKey"] => h["ParameterValue"])
      end
    end

    def existing_path
      "#{tmp_base}/existing.json"
    end

    def new_path
      "#{tmp_base}/new.json"
    end

    def tmp_base
      "/tmp/lono/diff/params"
    end

    def json_load(path)
      JSON.load(IO.read(path))
    end
  end
end
