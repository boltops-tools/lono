module Lono::Cfn
  class Plan < Base
    def run
      if stack_exists?(@stack)
        for_update
      else
        for_create
      end
    end

    def for_update
      # Allow passing down of the build object from Cfn::Deploy so build.all only runs once.
      # Fallback to creating new build object but still pass one build object instance down.
      @options[:build] ||= build
      if @options[:iam] == true
        @options[:iam] = Lono::Cfn::Deploy::Iam.new(@options)
      end
      Template.new(@options).run
      Param.new(@options).run
      changeset = Changeset.new(@options)
      changeset.create
      changeset # return changeset so it can be executed
    end

    def for_create
      New.new(@options).run
    end

    def for_delete
      Delete.new(@options).run
    end
  end
end
