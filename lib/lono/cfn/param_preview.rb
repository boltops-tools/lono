class Lono::Cfn
  class ParamPreview < Base
    delegate :required_parameters, :optional_parameters, :parameters, :data,
             to: :output_template

    include DiffViewer

    def run
      puts "Parameter Diff Preview:"
      if @options[:noop]
        puts "NOOP CloudFormation parameters preview for #{@stack_name} update"
        return
      end

      params = generate_all
      write_to_tmp(new_path, params)

      # TODO:
      # * if stack doesnt exist yet, dont generate any param preview
      # * if stack not found, handle gracefully
      # * convert to CloudFormation JSON format for diffing
      #
      write_to_tmp(existing_path, existing_parameters)

      show_diff(existing_path, new_path)
    end

    def existing_parameters
      resp = cfn.describe_stacks(stack_name: @stack_name)
      stack = resp.stacks.first
      parameters = stack.parameters

      # Remove optional parameters if they match already. Produces better diff.
      optional = optional_parameters.map do |logical_id, attributes|
        {
          "ParameterKey" => logical_id,
          "ParameterValue" => attributes["Default"],
        }
      end
      converted = convert_to_cfn_format(parameters)
      converted - optional
    end

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
