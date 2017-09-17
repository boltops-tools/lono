require "thor"

class Lono::Inspector < Lono::Command
  autoload :Help, 'lono/inspector/help'
  autoload :Base, 'lono/inspector/base'
  autoload :Params, 'lono/inspector/params'
  autoload :Depends, 'lono/inspector/depends'

  class_option :verbose, type: :boolean
  class_option :noop, type: :boolean
  class_option :project_root, desc: "Project folder.  Defaults to current directory", default: "."
  class_option :region, desc: "AWS region"

  desc "params STACK", "Prints report of CloudFormation template parameters"
  option :type, type: :string, desc: "type can be: all, required, optional", default: "all"
  long_desc Help.params
  def params(name)
    Params.new(name, options).run
  end

  desc "depends STACK", "Prints dependencies tree of CloudFormation template resources"
  long_desc Help.depends
  option :display, type: :string, desc: "graph or text", default: "graph"
  def depends(name)
    Depends.new(name, options).run
  end
end
