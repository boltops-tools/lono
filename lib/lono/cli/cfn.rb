class Lono::CLI
  class Cfn < Lono::Command
    opts = Lono::CLI::Cfn::Opts.new(self)

    desc "cancel BLUEPRINT", "Cancel a CloudFormation blueprint."
    long_desc Help.text("cfn/cancel")
    opts.cancel
    def cancel(blueprint)
      Lono::Cfn::Cancel.new(options.merge(blueprint: blueprint)).run
    end

    desc "download BLUEPRINT", "Download CloudFormation template from existing blueprint."
    long_desc Help.text("cfn/download")
    opts.download
    def download(blueprint)
      Lono::Cfn::Download.new(options.merge(blueprint: blueprint)).run
    end
  end
end
