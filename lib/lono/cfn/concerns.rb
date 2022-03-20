module Lono::Cfn
  module Concerns
    extend Memoist

    include Concerns::Build
    include Concerns::TemplateOutput

    def iam
      Deploy::Iam.new(@options)
    end
    memoize :iam

    def notification
      Deploy::Notification.new(@options)
    end
    memoize :notification

    def rollback
      Deploy::Rollback.new(@options)
    end
    memoize :rollback

    def operable
      Deploy::Operable.new(@options)
    end
    memoize :operable

    def plan
      Plan.new(@options.merge(build: build, iam: iam))
    end
    memoize :plan

    def status
      Status.new(@stack)
    end
    memoize :status

    def tags
      Deploy::Tags.new(@options)
    end
    memoize :tags
  end
end
