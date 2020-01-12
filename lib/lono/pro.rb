module Lono
  class Pro < Lono::Command
    desc "blueprints", "Lists available BoltOps Pro blueprints"
    long_desc Help.text(:blueprints)
    def blueprints
      Repo.new(options.merge(type: "blueprint")).run
    end

    desc "configsets", "Lists available BoltOps Pro configsets"
    long_desc Help.text(:configsets)
    def configsets
      Repo.new(options.merge(type: "configset")).run
    end
  end
end
