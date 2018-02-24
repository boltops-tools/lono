require "thor"

class Lono::Param < Lono::Command
  autoload :Generator, 'lono/param/generator'

  class_option :verbose, type: :boolean
  class_option :noop, type: :boolean
  class_option :mute, type: :boolean

  desc "generate", "Generate all parameter files to `output/params`."
  long_desc Lono::Help.text("param/generate")
  option :path, desc: "Name of the source that maps to the params txt file.  name -> params/NAME.txt.  Use this to override the params/NAME.txt convention"
  def generate
    Generator.generate_all(options)
  end
end
