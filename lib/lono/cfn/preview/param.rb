module Lono::Cfn::Preview
  class Param < Lono::Cfn::Base
    delegate :required_parameters, :optional_parameters, :parameters, :data,
             to: :output_template

    include DiffViewer
    include Lono::AwsServices

    def run
      return unless stack_exists?(@stack_name)

      puts "Parameter Diff Preview:".color(:green)
      if @options[:noop]
        puts "NOOP CloudFormation parameters preview for #{@stack_name} update"
        return
      end

      write_to_tmp(existing_path, existing_parameters)
      write_to_tmp(new_path, new_parameters)

      show_diff(existing_path, new_path)
    end

    def new_parameters
      params = generate_all
      params.reject { |p| ignore_parameters.include?(p[:parameter_key]) }
    end

    def existing_parameters
      existing = stack_parameters
      existing = existing.reject { |p| ignore_parameters.include?(p.parameter_key) }
      convert_to_cfn_format(existing)
    end

    def ignore_parameters
      # Remove optional parameters if they match already. Produces better diff.
      optional = optional_parameters.map { |logical_id, attributes| logical_id }
      noecho = stack_parameters.select { |p| p.parameter_value == '****' }
      noecho = noecho.map { |p| p.parameter_key }
      optional + noecho
    end
    memoize :ignore_parameters

    def stack_parameters
      resp = cfn.describe_stacks(stack_name: @stack_name)
      stack = resp.stacks.first
      stack.parameters
    end
    memoize :stack_parameters

  private
    def output_template
      Lono::OutputTemplate.new(@blueprint, @template)
    end
    memoize :output_template

    def write_to_tmp(path, list)
      converted = convert_to_cfn_format(list)
      text = JSON.pretty_generate(converted)
      FileUtils.mkdir_p(File.dirname(path))
      IO.write(path, text)
    end

    def convert_to_cfn_format(list)
      camelized = list.map(&:to_h).map do |h|
        h.transform_keys {|k| k.to_s.camelize}
      end
      camelized.sort_by { |h| h["ParameterKey"] }
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
