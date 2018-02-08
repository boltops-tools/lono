require "spec_helper"

describe Lono do
  before(:each) do
    lono_bin = "bin/lono"
    dir = File.dirname(Lono.root)
    name = File.basename(Lono.root)
    FileUtils.mkdir(dir) unless File.exist?(dir)
    execute("cd #{dir} && #{lono_bin} new #{name} -f -q --format json")
  end

  after(:each) do
    FileUtils.rm_rf(Lono.root) unless ENV['KEEP_TMP_PROJECT']
  end

  describe "bashify" do
    it "should convert cfn user_data to bash script" do
      path = "#{$root}/spec/fixtures/cfn.json"
      out = execute("./bin/lono template bashify #{path}")
      expect(out).to match /bash -lexv/
    end
  end

  describe "cli specs" do
    it "should generate templates" do
      out = execute("./bin/lono template generate -c")
      expect(out).to match /Generating CloudFormation templates/
    end

    it "should generate templates" do
      out = execute("./bin/lono template upload --noop")
      expect(out).to match /Templates uploaded to s3/
    end
  end
end
