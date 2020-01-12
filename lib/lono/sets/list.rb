require "text-table"

class Lono::Sets
  class List
    include Lono::AwsServices

    def initialize(options={})
      @options = options
    end

    def run
      table = Text::Table.new
      table.head = ["Stack Set Name", "Status"]
      summaries = stack_sets_summaries
      summaries.each do |s|
        table.rows << [s.stack_set_name, s.status]
      end
      puts table
    end

  private
    def stack_sets_summaries
      next_token, summaries = :start, []
      while next_token
        o = {}
        o[:next_token] = next_token unless next_token == :start or next_token.nil?
        o[:status] = @options[:status].upcase if @options[:status] && @options[:status] != "all"
        resp = cfn.list_stack_sets(o)
        next_token = resp.next_token
        summaries += resp.summaries
      end
      summaries
    end
  end
end
