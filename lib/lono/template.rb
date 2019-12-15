module Lono
  class Template < Command
    class_option :quiet, type: :boolean, desc: "silence the output"
    class_option :noop, type: :boolean, desc: "noop mode, do nothing destructive"

    desc "generate BLUEPRINT", "Generate the CloudFormation templates"
    long_desc Lono::Help.text("template/generate")
    option :clean, type: :boolean, desc: "remove all output files before generating"
    def generate(blueprint)
      Generator.new(options.merge(blueprint: blueprint)).run
    end

    desc "upload", "Uploads templates to configured s3 folder"
    def upload(blueprint)
      Upload.new(options.merge(blueprint: blueprint)).run
    end

    desc "bashify URL-OR-PATH", "Convert the UserData section of an existing CloudFormation Template to a starter bash script that is compatiable with lono"
    long_desc Lono::Help.text("template/bashify")
    def bashify(path)
      Bashify.new(options.merge(path: path)).run
    end
  end
end