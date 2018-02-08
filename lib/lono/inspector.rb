require "thor"

class Lono::Inspector < Lono::Command
  autoload :Help, 'lono/inspector/help'
  autoload :Base, 'lono/inspector/base'
  autoload :Depends, 'lono/inspector/depends'
  autoload :Summary, 'lono/inspector/summary'

  class_option :verbose, type: :boolean
  class_option :noop, type: :boolean

  desc "depends STACK", "Prints dependencies tree of CloudFormation template resources"
  long_desc Help.depends
  option :display, type: :string, desc: "graph or text", default: "graph"
  def depends(name)
    Depends.new(name, options).run
  end

  desc "summary STACK", "Prints summary of CloudFormation template"
  long_desc Help.summary
  def summary(name)
    Summary.new(name, options).run
  end
end
