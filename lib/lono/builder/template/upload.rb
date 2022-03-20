class Lono::Builder::Template
  class Upload < Lono::CLI::Base
    def run
      path = "#{Lono.root}/output/#{@blueprint.name}/template.yml"
      Lono::S3::Uploader.new(path).upload
    end
  end
end
