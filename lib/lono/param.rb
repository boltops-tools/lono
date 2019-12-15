module Lono
  class Param < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean
    class_option :mute, type: :boolean

    desc "generate BLUEPRINT", "Generate parameter output files to `output/params`."
    long_desc Lono::Help.text("param/generate")
    option :stack, desc: "stack name. defaults to blueprint name."
    def generate(blueprint)
      Generator.new(options.merge(blueprint: blueprint)).generate
    end
  end
end
