class Lono::Importer
  class Converter
    include Download

    # source is a path
    def initialize(options={})
      @options = options
      @source = options[:source]
    end

    def run
      tmp_path = "/tmp/lono/import/template.yml"
      tmp_template_path = download_template(@source, tmp_path)
      template = IO.read(tmp_template_path)
      coder = Service::Coder.new(template, @options)
      coder.translate
    end
  end
end
