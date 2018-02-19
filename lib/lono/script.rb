module Lono
  class Script < Command
    autoload :Base, "lono/script/base"
    autoload :Build, "lono/script/build"
    autoload :Upload, "lono/script/upload"

    desc "build", "Builds output/scripts/scripts-md5sum.tgz from app/script folder"
    long_desc Help.text("script/build")
    def build
      Build.new(options).run
    end

    desc "upload", "Uploads output/scripts/scripts-md5sum.tgz to s3"
    long_desc Help.text("script/upload")
    def upload
      Upload.new(options).run
    end
  end
end
