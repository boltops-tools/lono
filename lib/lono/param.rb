require "thor"

module Lono
  class Param < Lono::Command
    autoload :Generator, 'lono/param/generator'

    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean
    class_option :mute, type: :boolean

    desc "generate", "Generate all parameter files to `output/params`."
    long_desc Lono::Help.text("param/generate")
    def generate(blueprint=nil)
      Blueprint::Find.one_or_all(blueprint).each do |b|
        Generator.new(b, options).generate
      end
    end
  end
end
