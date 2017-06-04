require "thor"
require_relative "command"

module Lono
  class Template < Command
    autoload :Help, 'lono/template/help'
    autoload :Bashify, 'lono/template/bashify'
    autoload :DSL, 'lono/template/dsl'
    autoload :Template, 'lono/template/template'

    desc "generate", "Generate the CloudFormation templates"
    Help.generate
    option :clean, type: :boolean, aliases: "-c", desc: "remove all output files before generating"
    option :project_root, default: ".", aliases: "-r", desc: "project root"
    option :quiet, type: :boolean, aliases: "-q", desc: "silence the output"
    option :pretty, type: :boolean, default: true, desc: "json pretty the output.  only applies with json format"
    def generate
     DSL.new(options.clone).run
    end

    desc "bashify [URL-OR-PATH]", "Convert the UserData section of an existing CloudFormation Template to a starter bash script that is compatiable with lono"
    Help.bashify
    def bashify(path)
      Bashify.new(path: path).run
    end
  end
end
