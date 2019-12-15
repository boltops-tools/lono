class Lono::Cfn
  class Deploy < Base
    def save(parameters)
      if stack_exists?(@stack)
        Update.new(@options).save(parameters)
      else
        Create.new(@options).save(parameters)
      end
    end
  end
end
