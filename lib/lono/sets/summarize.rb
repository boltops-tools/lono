class Lono::Sets
  module Summarize
    def summarize(operation_id)
      puts "Stack Set Operation Summary:"
      resp = cfn.list_stack_set_operation_results(stack_set_name: @stack, operation_id: operation_id)
      resp.summaries.each do |s|
        data = {
          account: s.account,
          region: s.region,
          status: s.status,
        }
        data["status reason"] = s.status_reason if s.status_reason
        message = data.inject("") do |text, (k,v)|
          text += [k.to_s.color(:purple), v].join(" ") + " "
        end
        puts message
      end
    end
  end
end
