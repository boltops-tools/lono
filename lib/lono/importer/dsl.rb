class Lono::Importer
  class Dsl < Base
    def run
      tmp_template_path = download_template(@source, @tmp_path)
      template = IO.read(tmp_template_path)

      Lono::Blueprint::New.start([@blueprint, "--import", "--type", "dsl"])

      translate_to_dsl(template)
      create_params(tmp_template_path)
      # Let's not summarize the template in case the Ruby syntax is invalid with the import coder.
      # Add summarize back in later
      # summarize

      final_message
    end

    def translate_to_dsl(template)
      coder = Service::Coder.new(template, @options)
      result = coder.translate

      path = "#{Lono.config.templates_path}/#{@template}.rb"
      FileUtils.mkdir_p(File.dirname(path))
      create_file(path, result) # Thor::Action
    end

    def final_message
      puts <<~EOL
        #{"="*64}
        Congrats 🎉 You have successfully imported a lono blueprint.

        More info: https://lono.cloud/docs/core/blueprints
      EOL
    end
  end
end