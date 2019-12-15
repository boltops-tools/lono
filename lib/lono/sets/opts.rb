class Lono::Sets
  class Opts < Lono::Cfn::Opts
    def deploy
      super
      operation_preferences_options
    end

    def operation_preferences_options
      with_cli_scope do
        option :region_order, type: :array, desc: "region_order"
        option :failure_tolerance_count, type: :numeric, desc: "failure_tolerance_count"
        option :failure_tolerance_percentage, type: :numeric, desc: "failure_tolerance_percentage"
        option :max_concurrent_count, type: :numeric, desc: "max_concurrent_count"
        option :max_concurrent_percentage, type: :numeric, desc: "max_concurrent_percentage"
      end
    end
  end
end
