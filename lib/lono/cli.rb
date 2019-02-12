module Lono
  class CLI < Command

    long_desc Help.text(:new)
    New.cli_options.each do |args|
      option(*args)
    end
    register(New, "new", "new NAME", "Generates new lono project.")

    long_desc Help.text(:blueprint)
    Blueprint.cli_options.each do |args|
      option(*args)
    end
    register(Blueprint, "blueprint", "blueprint NAME", "Generates new lono blueprint.")

    desc "blueprints", "Lists available blueprints in the project."
    long_desc Help.text(:blueprints)
    def blueprints
      Blueprint::List.available
    end

    desc "generate", "Generate both CloudFormation templates and parameters files."
    long_desc Help.text(:generate)
    option :clean, type: :boolean, default: false, desc: "remove all output files before generating"
    option :quiet, type: :boolean, desc: "silence the output"
    def generate(blueprint=nil)
      Blueprint::Find.one_or_all(blueprint).each do |b|
        Script::Build.new(b, options).run
        Template::Generator.new(b, options).run
        Param::Generator.new(b, options).generate
      end
    end

    desc "user_data NAME", "Generates user_data script for debugging."
    long_desc Help.text(:user_data)
    option :clean, type: :boolean, default: true, desc: "remove all output/user_data files before generating"
    def user_data(blueprint, name)
      Script::Build.new(blueprint, options).run
      UserData.new(blueprint, options.merge(name: name)).generate
    end

    desc "summary BLUEPRINT TEMPLATE", "Prints summary of CloudFormation templates."
    long_desc Help.text("summary")
    def summary(blueprint=nil, template=nil)
      Lono::Inspector::Summary.new(blueprint, template, options).run
    end

    desc "xgraph STACK", "Graphs dependencies tree of CloudFormation template resources."
    long_desc Help.text("xgraph")
    option :display, type: :string, desc: "graph or text", default: "graph"
    option :noop, type: :boolean, desc: "noop mode"
    def xgraph(blueprint, template=nil)
      template ||= blueprint
      Lono::Inspector::Graph.new(blueprint, template, options).run
    end

    desc "configure", "Configure blueprint with starter values."
    option :defaults, type: :boolean, desc: "Bypass prompt and use the blueprints configure default values."
    option :param, desc: "override convention and specify the param file to use"
    option :seed, default: :convention, desc: "path to seed file to allow prompts bypass. yaml format."
    option :template, desc: "override convention and specify the template file to use"
    def configure(blueprint)
      Configure.new(blueprint, options).run
    end

    desc "clean", "Removes `output` folder."
    def clean
      Clean.new(options).run
    end

    desc "completion *PARAMS", "Prints words for auto-completion."
    long_desc Help.text("completion")
    def completion(*params)
      Completer.new(CLI, *params).run
    end

    desc "completion_script", "Generates a script that can be eval to setup auto-completion."
    long_desc Help.text("completion_script")
    def completion_script
      Completer::Script.generate
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

    desc "upgrade SUBCOMMAND", "upgrade subcommands"
    long_desc Help.text(:upgrade)
    subcommand "upgrade", Upgrade
  end
end
