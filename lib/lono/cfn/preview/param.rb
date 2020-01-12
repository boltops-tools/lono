module Lono::Cfn::Preview
  class Param < Lono::Cfn::Base
    delegate :required_parameters, :optional_parameters, :parameters, :data,
             to: :output_template

    include DiffViewer
    include Lono::AwsServices

    def run
      return unless stack_exists?(@stack)

      generated_parameters # eager call generated_parameters so its output is above Parameter Diff Preview
      puts "Parameter Diff Preview:".color(:green)
      if @options[:noop]
        puts "NOOP CloudFormation parameters preview for #{@stack} update"
        return
      end

      write_to_tmp(existing_path, existing_params)
      write_to_tmp(new_path, new_params)

      show_diff(existing_path, new_path)
    end

    def existing_params
      existing = stack_parameters
      params = normalize(existing)
      subtract(params, noecho_params)
    end
    memoize :existing_params

    def new_params
      params = optional_params.merge(generated_parameters)
      subtract(params, noecho_params)
    end

    # Remove items with the same key. The value can be different. This removes the noecho params.
    def subtract(h1,h2)
      hash = h1.reject do |k,v|
        h2.keys.include?(k)
      end
      Hash[hash.sort_by {|k,v| k}]
    end

    def generated_parameters
      parameters = generate_all
      normalize(parameters)
    end
    memoize :generated_parameters

    def optional_params
      # normalizing to simple Hash
      optional_parameters.inject({}) do |result,(k,v)|
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
    def output_template
      Lono::Output::Template.new(@blueprint, @template)
    end
    memoize :output_template

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
      "/tmp/lono/params-preview"
    end
  end
end
