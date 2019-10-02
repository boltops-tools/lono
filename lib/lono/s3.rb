module Lono
  class S3 < Command
    desc "deploy", "deploys lono managed s3 bucket"
    long_desc Help.text("s3/deploy")
    def deploy
      Bucket.new(options).deploy
    end

    desc "show", "shows lono managed s3 bucket"
    long_desc Help.text("s3/show")
    option :sure, type: :boolean, desc: "Bypass are you sure prompt"
    def show
      Bucket.new(options).show
    end

    desc "delete", "deletes lono managed s3 bucket"
    long_desc Help.text("s3/delete")
    option :sure, type: :boolean, desc: "Bypass are you sure prompt"
    def delete
      Bucket.new(options).delete
    end
  end
end
