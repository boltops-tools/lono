class Lono::Builder::Dsl::Finalizer
  class Configsets < Lono::CLI::Base
    def initialize(options={})
      super
      @cfn = options[:cfn]
    end

    # Replaces metadata under each logical id resource.
    def run
      dsl = Lono::Builder::Configset::Evaluator.new(@options.merge(cfn: @cfn))
      metadata_map = dsl.evaluate
      metadata_map.each do |logical_id, cs|
        resource = @cfn["Resources"][logical_id]
        unless resource
          puts "WARN: Resources.#{logical_id} not found in the template. Are you sure you specified the correct resource logical id in your configsets.rb?".color(:yellow)
          next
        end

        resource["Metadata"] = cs["Metadata"]
      end

      @cfn
    end
  end
end
