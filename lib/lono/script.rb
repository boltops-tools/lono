module Lono
  class Script < Command
    desc "build", "Builds `output/scripts/scripts-md5sum.tgz` from `app/script` folder"
    long_desc Help.text("script/build")
    def build(blueprint)
      Build.new(blueprint, options).run
    end

    desc "upload", "Uploads `output/scripts/scripts-md5sum.tgz` to s3"
    long_desc Help.text("script/upload")
    def upload(blueprint)
      Upload.new(blueprint, options).run
    end
  end
end
