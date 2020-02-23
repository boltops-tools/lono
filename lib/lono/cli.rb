module Lono
  class CLI < Command
    include Thor::Actions # for add_runtime_options
    opts = Opts.new(self)

    long_desc Help.text(:new)
    New.cli_options.each do |args|
      option(*args)
    end
    register(New, "new", "new NAME", "Generates new lono project.")

    desc "blueprints", "Lists blueprints"
    long_desc Help.text(:blueprints)
    def blueprints
      Finder::Blueprint.list
    end

    desc "configsets [BLUEPRINT]", "Lists configsets"
    long_desc Help.text(:configsets)
    opts.source
    opts.stack
    def configsets(blueprint=nil)
      Configset::List.new(options.merge(blueprint: blueprint)).run
    end

    desc "extensions [BLUEPRINT]", "Lists extensions"
    long_desc Help.text(:extensions)
    opts.source
    opts.stack
    def extensions(blueprint=nil)
      Extension::List.new(options.merge(blueprint: blueprint)).run
    end

    desc "generate BLUEPRINT", "Generate both CloudFormation templates and parameters files."
    long_desc Help.text(:generate)
    option :quiet, type: :boolean, desc: "silence the output"
    opts.clean
    opts.source
    opts.stack
    opts.template
    def generate(blueprint)
      o = options.merge(blueprint: blueprint)
      Script::Build.new(o).run
      Template::Generator.new(o).run
      Param::Generator.new(o).generate
    end

    desc "user_data NAME", "Generates user_data script for debugging."
    long_desc Help.text(:user_data)
    opts.clean
    def user_data(blueprint, name)
      Script::Build.new(blueprint, options).run
      UserData.new(blueprint, options.merge(name: name)).generate
    end

    desc "summary BLUEPRINT", "Prints summary of CloudFormation templates."
    long_desc Help.text("summary")
    opts.source
    opts.template
    def summary(blueprint)
      Lono::Inspector::Summary.new(options.merge(blueprint: blueprint)).run
    end

    desc "xgraph STACK", "Graphs dependencies tree of CloudFormation template resources."
    long_desc Help.text("xgraph")
    option :display, type: :string, desc: "graph or text", default: "graph"
    option :noop, type: :boolean, desc: "noop mode"
    opts.source
    opts.template
    def xgraph(blueprint)
      Lono::Inspector::Graph.new(options.merge(blueprint: blueprint)).run
    end

    desc "seed BLUEPRINT", "Generates starter configs for a blueprint."
    long_desc Help.text("seed")
    option :param, desc: "override convention and specify the param file to use"
    opts.source
    opts.template
    add_runtime_options! # Thor::Action options like --force
    def seed(blueprint)
      Seed.new(options.merge(blueprint: blueprint)).create
    end

    desc "app_files BLUEPRINT", "Builds app files", hide: true
    long_desc Help.text("app_files")
    add_runtime_options! # Thor::Action options like --force
    def app_files(blueprint)
      Lono::AppFile::Build.new(blueprint, options).run
    end

    desc "clean", "Removes `output` folder."
    def clean
      Clean.new(options).run
    end

    desc "upgrade", "Upgrade lono"
    long_desc Help.text("upgrade")
    def upgrade
      Upgrade.new(options).run
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
      puts "Lono: #{VERSION}"
    end

    desc "blueprint SUBCOMMAND", "blueprint subcommands"
    long_desc Help.text(:blueprint)
    subcommand "blueprint", Blueprint

    desc "cfn SUBCOMMAND", "cfn subcommands"
    long_desc Help.text(:cfn)
    subcommand "cfn", Cfn

    desc "code SUBCOMMAND", "code subcommands"
    long_desc Help.text(:code)
    subcommand "code", Code

    desc "configset SUBCOMMAND", "configset subcommands"
    long_desc Help.text(:configset)
    subcommand "configset", Configset

    desc "extension SUBCOMMAND", "extension subcommands"
    long_desc Help.text(:extension)
    subcommand "extension", Extension

    desc "param SUBCOMMAND", "param subcommands"
    long_desc Help.text(:param)
    subcommand "param", Param

    desc "pro SUBCOMMAND", "pro subcommands"
    long_desc Help.text(:pro)
    subcommand "pro", Pro

    desc "registration SUBCOMMAND", "registration subcommands"
    long_desc Help.text(:registration)
    subcommand "registration", Registration

    desc "s3 SUBCOMMAND", "s3 subcommands"
    long_desc Help.text(:s3)
    subcommand "s3", S3

    desc "script SUBCOMMAND", "script subcommands"
    long_desc Help.text(:script)
    subcommand "script", Script

    desc "sets SUBCOMMAND", "sets subcommands"
    long_desc Help.text(:sets)
    subcommand "sets", Sets

    desc "template SUBCOMMAND", "template subcommands"
    long_desc Help.text(:template)
    subcommand "template", Template
  end
end
