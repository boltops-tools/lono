module Lono
  class Code < Lono::Command
    desc "import SOURCE", "Imports CloudFormation template and converts it to Ruby code."
    long_desc Help.text("code/import")
    option :blueprint, default: nil, desc: "final blueprint name"
    option :casing, default: "as-is", desc: "Controls casing of logical ids. IE: as-is, camelcase or underscore"
    option :summary, default: true, type: :boolean, desc: "provide template summary after import"
    option :template, default: nil, desc: "final template name of downloaded template without extension"
    option :template_name_casing, default: "dasherize", desc: "camelcase or dasherize the template name"
    option :type, default: "dsl", desc: "import as a DSL or ERB template"
    def import(source)
      Importer.new(options.merge(source: source)).run
    end

    desc "convert SOURCE", "Converts snippet of JSON or YAML CloudFormation templates to Ruby code."
    long_desc Help.text("code/convert")
    option :casing, default: "as-is", desc: "Controls casing of logical ids. IE: as-is, camelcase or underscore"
    def convert(source)
      Importer::Converter.new(options.merge(source: source)).run
    end
  end
end
