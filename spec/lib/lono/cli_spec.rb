describe Lono::CLI do
  it "new generate new project" do
    # using another name for the lono project because we call
    # exe/lono new lono_project for all specs via the RSpec.config already
    out = execute("exe/lono new test_project --no-bundle")
    exist = File.exist?("tmp/test_project/config/settings.yml")
    expect(exist).to be true
    FileUtils.rm_rf("tmp/test_project")
  end

  it "generate should build templates" do
    out = execute("exe/lono generate")
    success = $?.exitstatus == 0
    expect(success).to be true
  end

  it "import should download template" do
    # hack to get this spec working and not change the original base.rb
    path = "spec/fixtures/lono_project/app/stacks/base.rb"
    backup = "spec/fixtures/lono_project/app/stacks/base.rb.bak"
    FileUtils.cp(path, backup)

    out = execute("exe/lono import spec/fixtures/raw_templates/aws-waf-security-automations.template")
    expect(out).to match /Imported raw CloudFormation template/

    FileUtils.mv(backup, path)
  end
end

