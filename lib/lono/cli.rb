require 'thor'
require 'lono/command'

module Lono
  autoload :Help, 'lono/help'
  class CLI < Lono::Command

    desc "new [NAME]", "Generates lono starter project"
    long_desc Help.new_long_desc
    option :force, type: :boolean, aliases: "-f", desc: "override existing starter files"
    option :quiet, type: :boolean, aliases: "-q", desc: "silence the output"
    option :format, type: :string, default: "yaml", desc: "starter project template format: json or yaml"
    def new(project_root)
      Lono::New.new(options.clone.merge(project_root: project_root)).run
    end

    desc "import [SOURCE]", "Imports raw CloudFormation template and lono-fies it"
    long_desc Help.import
    option :format, type: :string, default: "yaml", desc: "format for the final template"
    option :project_root, default: ".", aliases: "-r", desc: "project root"
    option :casing, default: "underscore", desc: "camelcase or underscore the template name"
    def import(source)
      Importer.new(source, options).run
    end

    desc "generate", "Generate both CloudFormation templates and parameters files"
    Help.generate
    option :clean, type: :boolean, aliases: "-c", desc: "remove all output files before generating"
    option :project_root, default: ".", aliases: "-r", desc: "project root"
    option :quiet, type: :boolean, aliases: "-q", desc: "silence the output"
    option :pretty, type: :boolean, default: true, desc: "json pretty the output.  only applies with json format"
    def generate
      puts "Generating both CloudFormation template and parameter files."
      Lono::Template::DSL.new(options.clone).run
      Lono::Param::Generator.generate_all(options.clone)
    end

    desc "clean", "Clean up generated files"
    def clean
      Lono::Clean.new(options.clone).run
    end

    desc "version", "Prints version"
    def version
      puts Lono::VERSION
    end

    desc "template ACTION", "template subcommand tasks"
    long_desc Help.template
    subcommand "template", Template

    desc "cfn ACTION", "cfn subcommand tasks"
    long_desc Help.cfn
    subcommand "cfn", Cfn

    desc "param ACTION", "param subcommand tasks"
    long_desc Help.param
    subcommand "param", Lono::Param
  end
end
