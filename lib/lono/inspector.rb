require "thor"

class Lono::Inspector < Lono::Command
  autoload :Base, 'lono/inspector/base'
  autoload :Depend, 'lono/inspector/depend'
  autoload :Summary, 'lono/inspector/summary'

  class_option :verbose, type: :boolean
  class_option :noop, type: :boolean

  desc "depends STACK", "Prints dependencies tree of CloudFormation template resources"
  long_desc Lono::Help.text("inspect/depends")
  option :display, type: :string, desc: "graph or text", default: "graph"
  def depends(name)
    Depend.new(name, options).run
  end

  desc "summary STACK", "Prints summary of CloudFormation template"
  long_desc Lono::Help.text("inspect/summary")
  def summary(name)
    Summary.new(name, options).run
  end
end
