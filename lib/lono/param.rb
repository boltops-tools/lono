module Lono
  class Param < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean
    class_option :mute, type: :boolean

    desc "generate", "Generate parameter output files to `output/params`."
    long_desc Lono::Help.text("param/generate")
    option :stack, desc: "stack name. defaults to blueprint name."
    def generate(blueprint=nil)
      Blueprint::Find.one_or_all(blueprint).each do |b|
        Generator.new(b, options).generate
      end
    end
  end
end
