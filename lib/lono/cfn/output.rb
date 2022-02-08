module Lono::Cfn
  class Output < Base
    def run
      stack = find_stack(@stack)
      unless stack
        logger.info "ERROR: stack #{@stack} not found".color(:red)
        quit 1
      end

      outputs = stack.outputs.map(&:to_h)
      logger.info <<~EOL
        #{"Outputs:".color(:green)}

      EOL
      if outputs.empty?
        logger.stdout outputs.inspect
      else
        logger.stdout pretty(outputs)
      end
    end

  private
    # Input:
    #
    #      [{
    #        output_key: "SecurityGroup",
    #        output_value: "demo-dev-SecurityGroup-142DZFIEG3G9L"
    #      }]
    #
    # Output:
    #
    #      { "SecurityGroup" => "demo-dev-SecurityGroup-142DZFIEG3G9L" }
    #
    def pretty(outputs)
      outs = outputs.inject({}) do |result,h|
        result.merge!(h[:output_key] => h[:output_value])
      end
      default = {format: "equal"}
      options = default.merge(@options.symbolize_keys)
      presenter = CliFormat::Presenter.new(options)
      presenter.header = ["Key", "Value"] unless presenter.format == "equal"
      outs.keys.sort.each do |k|
        row = [k,outs[k]]
        presenter.rows << row
      end
      presenter.show
    end
  end
end
