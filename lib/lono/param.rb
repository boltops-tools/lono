require "thor"

class Lono::Param < Lono::Command
  autoload :Help, 'lono/param/help'
  autoload :Generator, 'lono/param/generator'

  class_option :verbose, type: :boolean
  class_option :noop, type: :boolean
  class_option :mute, type: :boolean
  class_option :project_root, desc: "project root to use", default: '.'

  desc "generate", "generate all parameter files to json format"
  long_desc Help.generate
  option :path, desc: "Name of the source that maps to the params txt file.  name -> params/NAME.txt.  Use this to override the params/NAME.txt convention"
  def generate
    Generator.generate_all(options)
  end
end
