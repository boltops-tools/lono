module Lono::Cfn
  class Plan < Base
    def run
      build.all
      if stack_exists?(@stack)
        for_update
      else
        for_create
      end
    end

    def for_update
      upload_all
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
      upload_all
      New.new(@options).run
    end

    def for_delete
      Delete.new(@options).run
    end

    # important to call before for_update and for_create
    # since changeset requires the template to already be uploaded to s3
    def upload_all
      upload_templates
      upload_files
    end

    def upload_templates
      Lono::Builder::Template::Upload.new(@options).run
    end

    # Upload files right before create_stack or execute_change_set
    # Its better to upload here as part of a deploy vs a build
    # IE: lono build should try not to do a remote write to s3 if possible
    def upload_files
      # Files built and compressed in
      #     Lono::Builder::Dsl::Finalizer::Files::Build#build_files
      Lono::Files.files.each do |file| # using singular file, but is like a "file_list"
        file.upload
      end
    end

  end
end
