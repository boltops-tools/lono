require "thor"
require_relative "command"

class Lono::Template < Lono::Command
  autoload :Help, 'lono/template/help'
  autoload :Helpers, 'lono/template/helpers'
  autoload :Bashify, 'lono/template/bashify'
  autoload :DSL, 'lono/template/dsl'
  autoload :Template, 'lono/template/template'
  autoload :Upload, 'lono/template/upload'
  autoload :AwsServices, 'lono/template/aws_services'

  class_option :quiet, type: :boolean, aliases: "-q", desc: "silence the output"
  class_option :noop, type: :boolean, desc: "noop mode, do nothing destructive"

  desc "generate", "Generate the CloudFormation templates"
  Help.generate
  option :clean, type: :boolean, aliases: "-c", desc: "remove all output files before generating"
  option :project_root, default: ".", aliases: "-r", desc: "project root"
  option :pretty, type: :boolean, default: true, desc: "json pretty the output.  only applies with json format"
  def generate
    DSL.new(options.clone).run
  end

  desc "upload", "Uploads templates to configured s3 folder"
  option :project_root, default: ".", aliases: "-r", desc: "project root"
  def upload
    Upload.new(options.clone).run
  end

  desc "bashify [URL-OR-PATH]", "Convert the UserData section of an existing CloudFormation Template to a starter bash script that is compatiable with lono"
  Help.bashify
  def bashify(path)
    Bashify.new(path: path).run
  end
end
