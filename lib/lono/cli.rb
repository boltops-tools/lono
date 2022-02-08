module Lono
  class CLI < Command
    include Help
    include Thor::Actions # for add_runtime_options
    opts = Opts.new(self)
    cfn_opts = Lono::CLI::Cfn::Opts.new(self)

    desc "build BLUEPRINT", "Build both CloudFormation template and parameters files"
    long_desc Help.text(:build)
    option :quiet, type: :boolean, desc: "silence the output"
    opts.clean
    def build(blueprint)
      Build.new(options.merge(blueprint: blueprint, build_only: true)).all
    end

    desc "bundle", "Bundle with Lonofile."
    long_desc Help.text(:bundle)
    def bundle(*args)
      Bundle.new(options.merge(args: args)).run
    end

    desc "clean", "Removes `output` folder."
    opts.yes
    def clean
      Clean.new(options).run
    end

    desc "down BLUEPRINT", "Delete CloudFormation blueprint"
    long_desc Help.text(:down)
    cfn_opts.delete
    def down(blueprint)
      Lono::Cfn::Delete.new(options.merge(blueprint: blueprint)).run
    end

    desc "list", "List blueprints, configsets, extensions, etc"
    long_desc Help.text(:list)
    option :type, aliases: :t, desc: "Type: IE: blueprint, configset, extension. Defaults to all"
    def list
      List.new(options).run
    end

    desc "output BLUEPRINT", "output or preview of the deploy"
    long_desc Help.text(:output)
    option :format, desc: "Output formats: #{CliFormat.formats.join(', ')}"
    def output(blueprint)
      Lono::Cfn::Output.new(options.merge(blueprint: blueprint)).run
    end

    desc "plan BLUEPRINT", "Plan or preview of the deploy"
    long_desc Help.text(:plan)
    option :out, aliases: :o, desc: "Write Change Set info to path"
    def plan(blueprint)
      Lono::Cfn::Plan.new(options.merge(blueprint: blueprint)).run
    end

    desc "seed BLUEPRINT", "Builds starter configs for a blueprint."
    long_desc Help.text("seed")
    option :param, desc: "override convention and specify the param file to use"
    opts.runtime_options
    def seed(blueprint)
      Seed.new(options.merge(blueprint: blueprint)).create
    end

    desc "show BLUEPRINT", "Deploy CloudFormation stack"
    long_desc Help.text(:show)
    def show(blueprint)
      Lono::Cfn::Show.new(options.merge(blueprint: blueprint)).run
    end

    desc "status BLUEPRINT", "Shows current status of blueprint."
    long_desc Help.text(:status)
    def status(blueprint)
      names = Lono::Names.new(blueprint: blueprint)
      status = Lono::Cfn::Status.new(names.stack, options)
      success = status.run
      exit 3 unless success
    end

    desc "summary BLUEPRINT", "Prints summary of CloudFormation template"
    long_desc Help.text("summary")
    def summary(blueprint)
      Lono::Inspector::Summary.new(options.merge(blueprint: blueprint)).run
    end

    desc "test", "Run test."
    long_desc Help.text(:test)
    def test
      Test.new(options).run
    end

    desc "up BLUEPRINT", "Deploy CloudFormation stack"
    long_desc Help.text(:up)
    cfn_opts.deploy
    def up(blueprint)
      Lono::Cfn::Deploy.new(options.merge(blueprint: blueprint)).run
    end

    desc "user_data BLUEPRINT NAME", "Generates user_data script for debugging."
    long_desc Help.text(:user_data)
    opts.clean
    def user_data(blueprint, name)
      Script::Build.new(options.merge(blueprint: blueprint)).run
      UserData.new(options.merge(blueprint: blueprint, name: name)).generate
    end

    desc "completion *PARAMS", "Prints words for auto-completion"
    long_desc Help.text("completion")
    def completion(*params)
      Completer.new(CLI, *params).run
    end

    desc "completion_script", "Builds a script that can be eval to setup auto-completion"
    long_desc Help.text("completion_script")
    def completion_script
      Completer::Script.build
    end

    desc "version", "Prints version"
    def version
      puts "Lono: #{VERSION}"
    end

    desc "cfn SUBCOMMAND", "cfn subcommands"
    long_desc Help.text(:cfn)
    subcommand "cfn", Cfn

    desc "code SUBCOMMAND", "code subcommands"
    long_desc Help.text(:code)
    subcommand "code", Code

    desc "new SUBCOMMAND", "new subcommands"
    long_desc Help.text(:new)
    subcommand "new", New

    desc "s3 SUBCOMMAND", "s3 subcommands"
    long_desc Help.text(:s3)
    subcommand "s3", S3

    desc "script SUBCOMMAND", "script subcommands"
    long_desc Help.text(:script)
    subcommand "script", Script
  end
end
