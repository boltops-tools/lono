class Lono::Sets
  class Waiter
    include Lono::Sets::Summarize

    def initialize(options)
      @options = options
      @stack = options[:stack]
      @wait = @options[:wait].nil? ? true : @options[:wait]
    end

    def run(operation_id)
      message = "Deploying #{@stack} stack set"
      puts message unless @options[:mute]
      return unless @wait

      status = Status.new(@options.merge(operation_id: operation_id))
      success = status.wait
      summarize(operation_id)
      exit 1 unless success
      success
    end
  end
end
