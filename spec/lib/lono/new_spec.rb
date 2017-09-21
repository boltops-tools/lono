require_relative "../../spec_helper"

describe Lono::New do
  before(:each) do
    @project_root = File.expand_path("../../../../tmp/lono_project", __FILE__)
  end
  after(:each) do
    FileUtils.rm_rf(@project_root) unless ENV['KEEP_TMP_PROJECT']
  end

  context "json starter project" do
    before(:each) do
      new_project = Lono::New.new(
        force: true,
        quiet: true,
        format: 'json',
        project_root: @project_root
      )
      new_project.run
    end

    it "should be able to lono generate" do
      dsl = Lono::Template::DSL.new(
        project_root: @project_root,
        quiet: true
      )
      dsl.run
      generated = File.exist?("#{@project_root}/output/blog-web.json")
      expect(generated).to be true
    end
  end

  context "yml starter project" do
    before(:each) do
      new_project = Lono::New.new(
        force: true,
        quiet: true,
        format: 'yaml',
        project_root: @project_root
      )
      new_project.run
    end

    it "should be able to lono generate" do
      dsl = Lono::Template::DSL.new(
        project_root: @project_root,
        quiet: true
      )
      dsl.run
      generated = File.exist?("#{@project_root}/output/blog-web.yml")
      expect(generated).to be true
    end
  end

  context "multiple format starter project" do
    # TODO: this should not generate anything but puts out a message to the user that the
    # project needs to be either all yaml or all json format
  end
end
