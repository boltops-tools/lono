class Lono::Sets::Instances
  class Status
    def initialize(options={})
      @options = options
    end

    def run(to: "completed")
      instances = Lono::Sets::Status::Instances.new(@options)
      instances.wait(to)
    end
  end
end
