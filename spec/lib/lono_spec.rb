require File.expand_path("../../spec_helper", __FILE__)

describe Lono do
  before(:each) do
    @project_root = File.expand_path("../../project", __FILE__)
    @dsl = Lono::DSL.new(
      :config_path => "#{@project_root}/config/lono.rb",
      :project_root => @project_root
    )
    @dsl.evaluate
  end

  after(:each) do
    FileUtils.rm_rf("#{@project_root}/output")
  end

  it "should generate cloud formation template" do
    @dsl.build
    @dsl.output(:output_path => "#{@project_root}/output")
    raw = IO.read("#{@project_root}/output/prod-api-app.json")
    json = JSON.load(raw)
    json['Description'].should == "Api Stack"
    json['Mappings']['AWSRegionArch2AMI']['us-east-1']['64'].should == 'ami-123'
  end
end

describe Lono::Task do
  before(:each) do
    @project_root = File.expand_path("../../project", __FILE__)
  end

  after(:each) do
    FileUtils.rm_rf("#{@project_root}/output")
  end

  it "task should generate cloud formation templates" do
    Lono::Task.generate(
      :project_root => @project_root,
      :config_path => "#{@project_root}/config/lono.rb",
      :output_path => "#{@project_root}/output"
    )
    raw = IO.read("#{@project_root}/output/prod-api-app.json")
    json = JSON.load(raw)
    json['Description'].should == "Api Stack"
    json['Mappings']['AWSRegionArch2AMI']['us-east-1']['64'].should == 'ami-123'
  end
end
