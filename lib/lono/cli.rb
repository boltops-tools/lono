module Lono
  class CLI < Command

    long_desc Help.text(:new)
    New.cli_options.each do |args|
      option *args
    end
    register(New, "new", "new NAME", "generates new CLI project")

    desc "import SOURCE", "Imports CloudFormation template and lono-fies it."
    long_desc Help.text(:import)
    option :name, required: true, default: nil, desc: "final name of downloaded template without extension"
    option :summary, default: true, type: :boolean, desc: "provide template summary after import"
    def import(source)
      Importer.new(source, options).run
    end

    desc "generate", "Generate both CloudFormation templates and parameters files"
    long_desc Help.text(:generate)
    option :clean, type: :boolean, default: true, desc: "remove all output files before generating"
    option :quiet, type: :boolean, desc: "silence the output"
    def generate
      puts "Generating CloudFormation templates, parameters, and scripts"
      Script::Build.new(options).run
      Template::DSL.new(options).run
      Param::Generator.generate_all(options)
    end

    desc "user_data NAME", "Generates user_data script for debugging"
    long_desc Help.text(:user_data)
    option :clean, type: :boolean, default: true, desc: "remove all output/user_data files before generating"
    def user_data(name)
      Script::Build.new(options).run
      UserData.new(options.merge(name: name)).generate
    end

    desc "summary STACK", "Prints summary of CloudFormation template"
    long_desc Help.text("summary")
    def summary(name)
      Lono::Inspector::Summary.new(name, options).run
    end

    desc "xgraph STACK", "Graphs dependencies tree of CloudFormation template resources"
    long_desc Help.text("xgraph")
    option :display, type: :string, desc: "graph or text", default: "graph"
    option :noop, type: :boolean, desc: "noop mode"
    def xgraph(name)
      Lono::Inspector::Graph.new(name, options).run
    end

    desc "clean", "Clean up generated files in `output` folder."
    def clean
      Clean.new(options).run
    end

    desc "completion *PARAMS", "prints words for auto-completion"
    long_desc Help.text("completion")
    def completion(*params)
      Completer.new(CLI, *params).run
    end

    desc "completion_script", "generates script that can be eval to setup auto-completion"
    long_desc Help.text("completion_script")
    def completion_script
      Completer::Script.generate
    end

    desc "upgrade4", "Upgrade from version 3 to 4."
    long_desc Help.text("upgrade4")
    def upgrade4
      Upgrade4.new(options).run
    end

    desc "version", "Prints version"
    def version
      puts VERSION
    end

    desc "template SUBCOMMAND", "template subcommands"
    long_desc Help.text(:template)
    subcommand "template", Template

    desc "cfn SUBCOMMAND", "cfn subcommands"
    long_desc Help.text(:cfn)
    subcommand "cfn", Cfn

    desc "param SUBCOMMAND", "param subcommands"
    long_desc Help.text(:param)
    subcommand "param", Param

    desc "script SUBCOMMAND", "script subcommands"
    long_desc Help.text(:script)
    subcommand "script", Script
  end
end
