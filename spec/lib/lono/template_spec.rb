require_relative "../../spec_helper"

describe Lono do
  before(:each) do
    lono_bin = File.expand_path("../../../../bin/lono", __FILE__)
    @project_root = File.expand_path("../../../../tmp/lono_project", __FILE__)
    dir = File.dirname(@project_root)
    name = File.basename(@project_root)
    FileUtils.mkdir(dir) unless File.exist?(dir)
    execute("cd #{dir} && #{lono_bin} new #{name} -f -q --format json")
  end

  after(:each) do
    FileUtils.rm_rf(@project_root) unless ENV['KEEP_TMP_PROJECT']
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
      out = execute("./bin/lono template generate -c --project-root #{@project_root}")
      expect(out).to match /Generating CloudFormation templates/
    end

    it "should generate templates" do
      out = execute("./bin/lono template upload --project-root #{@project_root} --noop")
      expect(out).to match /Templates uploaded to s3/
    end
  end
end
