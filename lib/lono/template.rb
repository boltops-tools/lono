require "thor"
require_relative "command"

class Lono::Template < Lono::Command
  autoload :Context, 'lono/template/context'
  autoload :Helper, 'lono/template/helper'
  autoload :Bashify, 'lono/template/bashify'
  autoload :DSL, 'lono/template/dsl'
  autoload :Template, 'lono/template/template'
  autoload :Upload, 'lono/template/upload'
  autoload :AwsService, 'lono/template/aws_service'

  class_option :quiet, type: :boolean, desc: "silence the output"
  class_option :noop, type: :boolean, desc: "noop mode, do nothing destructive"

  desc "generate", "Generate the CloudFormation templates"
  long_desc Lono::Help.text("template/generate")
  option :clean, type: :boolean, desc: "remove all output files before generating"
  def generate
    DSL.new(options.clone).run
  end

  desc "upload", "Uploads templates to configured s3 folder"
  def upload
    Upload.new(options.clone).run
  end

  desc "bashify URL-OR-PATH", "Convert the UserData section of an existing CloudFormation Template to a starter bash script that is compatiable with lono"
  long_desc Lono::Help.text("template/bashify")
  def bashify(path)
    Bashify.new(path: path).run
  end
end
