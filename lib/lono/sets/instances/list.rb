class Lono::Sets::Instances
  class List
    include Lono::AwsServices

    def initialize(options={})
      @options = options
    end

    def run
      Lono::Sets::Status::Instances.new(@options).show
    end
  end
end
