class Lono::Cfn
  class ParamPreview < Base
    include DiffViewer

    def run
      puts "ParamPreview#run"

      if @options[:noop]
        puts "NOOP CloudFormation parameters preview for #{@stack_name} update"
        return
      end

      params = generate_all
      write_to_tmp(existing_path, params)

      # TODO:
      # * if stack doesnt exist yet, dont generate any param preview
      # * if stack not found, handle gracefully
      # * convert to CloudFormation JSON format for diffing
      #
      # * remove optional parameters unless they were also passed
      resp = cfn.describe_stacks(stack_name: @stack_name)
      stack = resp.stacks.first
      write_to_tmp(new_path, stack.parameters)

      show_diff(existing_path, new_path)
    end

    def write_to_tmp(path, list)
      converted = convert_to_cfn_format(list)
      yaml = YAML.dump(converted)
      FileUtils.mkdir_p(File.dirname(path))
      IO.write(path, yaml)
    end

    def convert_to_cfn_format(list)
      camelized = list.map(&:to_h).map do |h|
        h.transform_keys {|k| k.to_s.camelize}
      end
      camelized.sort_by { |h| h["ParameterKey"] }
    end

    def existing_path
      "#{tmp_base}/existing.yml"
    end

    def new_path
      "#{tmp_base}/new.yml"
    end

    def tmp_base
      "/tmp/lono/params-preview"
    end
  end
end
