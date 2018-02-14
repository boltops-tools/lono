describe Lono::CLI do
  it "generate should build templates" do
    out = execute("exe/lono generate")
    expect(out).to match /Generating both CloudFormation template and parameter/
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

