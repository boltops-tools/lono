class Lono::CLI
  class S3 < Lono::Command
    opts = Opts.new(self)

    desc "deploy", "deploys lono managed s3 bucket"
    long_desc Help.text("s3/deploy")
    def deploy
      Lono::S3::Bucket.new(options).deploy
    end

    desc "show", "shows lono managed s3 bucket"
    long_desc Help.text("s3/show")
    opts.yes
    def show
      Lono::S3::Bucket.new(options).show
    end

    desc "delete", "deletes lono managed s3 bucket"
    long_desc Help.text("s3/delete")
    opts.yes
    def delete
      Lono::S3::Bucket.new(options).delete
    end
  end
end
