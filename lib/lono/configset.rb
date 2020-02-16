module Lono
  class Configset < Command
    long_desc Help.text("configset/new")
    New.cli_options.each do |args|
      option(*args)
    end
    register(New, "new", "new NAME", "Generates new lono configset.")

    desc "generate", "Generate configset from DSL"
    long_desc Help.text(:generate)
    option :resource, default: "PretendResource", desc: "Set the @resource instance variable availalbe in the configset"
    def generate(configset)
      Generator.new(options.merge(configset: configset)).run
    end
  end
end
