class Lono::Cfn::Plan
  class Base < Lono::Cfn::Base
    def initialize(options={})
      super
      # Allow build and iam to be passed from Cfn::Deploy. Reasons:
      #
      #   1. build.all only needs to be called once.
      #   2. iam.capabilities can be adjusted with retry
      #   3. objects are passed in a clear single direction.
      #
      # However, for CLI commands like `lono plan`, no objects are passed.
      # In this case, new instances are created. In both cases the same options
      # to the build and iam instances are used.
      #
      @build = options[:build] || build
      @iam = options[:iam] || iam
    end
  end
end
