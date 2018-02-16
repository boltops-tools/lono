describe Lono::Param::Generator do
  let(:setting) do
    setting = Lono::Setting.new(check_lono_project=false)
    allow(setting).to receive(:data).and_return(data)
    setting
  end
  context "simple string" do
    let(:data) do
      {
        "s3_path" => "s3-bucket/simple/string/example"
      }
    end
    it "should return simple string value" do
      value = setting.s3_path
      expect(value).to eq "s3-bucket/simple/string/example"
    end
  end

  context "options hash" do
    let(:data) do
      {
        "s3_path" => {
          "default" => "s3-bucket/default/path",
          "aws_profile1" => "s3-bucket/aws_profile1/path",
        }
      }
    end
    it "should return default value when AWS_PROFILE not set" do
      saved = ENV['AWS_PROFILE']

      value = setting.s3_path
      expect(value).to eq "s3-bucket/default/path"

      ENV['AWS_PROFILE'] = saved
    end

    it "should return AWS_PROFILE value when AWS_PROFILE set" do
      saved = ENV['AWS_PROFILE']
      ENV['AWS_PROFILE'] = "aws_profile1"

      value = setting.s3_path
      expect(value).to eq "s3-bucket/aws_profile1/path"

      ENV['AWS_PROFILE'] = saved
    end
  end
end
