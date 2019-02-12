class Lono::Cfn
  class Deploy < Base
    def save_stack(params)
      if stack_exists?(@stack_name)
        Update.new(@stack_name, @options).update_stack(params)
      else
        Create.new(@stack_name, @options).create_stack(params)
      end
    end
  end
end
