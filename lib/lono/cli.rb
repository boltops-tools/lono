module Lono
  class CLI < Command

    long_desc Help.text(:new)
    New.cli_options.each do |args|
      option *args
    end
    register(New, "new", "new NAME", "generates new CLI project")

    desc "import SOURCE", "Imports raw CloudFormation template and lono-fies it"
    long_desc Help.text(:import)
    option :format, type: :string, default: "yaml", desc: "format for the final template"
    option :casing, default: "underscore", desc: "camelcase or underscore the template name"
    option :name, required: true, default: nil, desc: "final name of downloaded template without extension"
    option :summary, default: true, type: :boolean, desc: "provide template summary after import"
    def import(source)
      Importer.new(source, options).run
    end

    desc "generate", "Generate both CloudFormation templates and parameters files"
    long_desc Help.text(:generate)
    option :clean, type: :boolean, desc: "remove all output files before generating"
    option :quiet, type: :boolean, desc: "silence the output"
    option :pretty, type: :boolean, default: true, desc: "json pretty the output.  only applies with json format"
    def generate
      puts "Generating both CloudFormation template and parameter files."
      Template::DSL.new(options.clone).run
      Param::Generator.generate_all(options.clone)
    end

    desc "clean", "Clean up generated files"
    def clean
      Clean.new(options.clone).run
    end

    desc "completion *PARAMS", "prints words for auto-completion"
    long_desc Help.text("completion")
    def completion(*params)
      Completer.new(CLI, *params).run
    end

    desc "completion_script", "generates script that can be eval to setup auto-completion", hide: true
    long_desc Help.text("completion_script")
    def completion_script
      Completer::Script.generate
    end

    desc "upgrade4", "upgrade from version 3 to 4"
    long_desc Help.text("upgrade3")
    def upgrade4
      Upgrade4.new(options).run
    end

    desc "version", "Prints version"
    def version
      puts VERSION
    end

    desc "template SUBCOMMAND", "template subcommand tasks"
    long_desc Help.text(:template)
    subcommand "template", Template

    desc "cfn SUBCOMMAND", "cfn subcommand tasks"
    long_desc Help.text(:cfn)
    subcommand "cfn", Cfn

    desc "param SUBCOMMAND", "param subcommand tasks"
    long_desc Help.text(:param)
    subcommand "param", Param

    desc "inspect SUBCOMMAND", "inspect subcommand tasks"
    long_desc Help.text(:inspect)
    subcommand "inspect", Inspector
  end
end
