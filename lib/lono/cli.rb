module Lono
  class CLI < Command

    desc "new NAME", "Generates lono starter project"
    long_desc Help.text(:new)
    option :force, type: :boolean, desc: "override existing starter files"
    option :quiet, type: :boolean, desc: "silence the output"
    option :format, type: :string, default: "yaml", desc: "starter project template format: json or yaml"
    def new(project_root)
      New.new(options.clone.merge(project_root: project_root)).run
    end

    desc "import SOURCE", "Imports raw CloudFormation template and lono-fies it"
    long_desc Help.text(:import)
    option :format, type: :string, default: "yaml", desc: "format for the final template"
    option :casing, default: "underscore", desc: "camelcase or underscore the template name"
    option :name, default: nil, desc: "final name of downloaded template without extension"
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
    long_desc Help.text(:inspector)
    subcommand "inspect", Inspector
  end
end
