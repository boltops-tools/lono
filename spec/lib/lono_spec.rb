require File.expand_path("../../spec_helper", __FILE__)

describe Lono do
  before(:each) do
    @project = File.expand_path("../../project", __FILE__)
    FileUtils.mkdir(@project) unless File.exist?(@project)
    execute("./bin/lono init -f -q --project-root #{@project}")
  end

  after(:each) do
    FileUtils.rm_rf(@project)
  end

  describe "ruby specs" do
    before(:each) do
      @dsl = Lono::DSL.new(
        :project_root => @project,
        :quiet => true
      )
      @dsl.run
    end

    it "should generate cloud formation template" do
      raw = IO.read("#{@project}/output/prod-api-app.json")
      json = JSON.load(raw)
      json['Description'].should == "Api Stack"
      json['Mappings']['AWSRegionArch2AMI']['us-east-1']['64'].should == 'ami-123'
    end

    it "should generate db template" do
      raw = IO.read("#{@project}/output/prod-api-redis.json")
      json = JSON.load(raw)
      json['Description'].should == "Api redis"
      user_data = json['Resources']['server']['Properties']['UserData']['Fn::Base64']['Fn::Join'][1]
      user_data.should include({"Ref" => "AWS::StackName"})
      user_data.should include({"Ref" => "WaitHandle"})
      user_data.should include({
        "Fn::FindInMap" => [
          "EnvironmentMapping",
          "HostnamePrefix",
          {"Ref" => "Environment"}
        ]
      })
      user_data.should include({
        "Fn::FindInMap" => [
          "MapName",
          "TopLevelKey",
          "SecondLevelKey"
        ]
      })
      user_data.should include({"Ref" => "DRINK"})

      user_data.should include({"Fn::Base64" => "value to encode"})
      user_data.should include({"Fn::GetAtt" => ["server", "PublicDnsName"]})
      user_data.should include({"Fn::GetAZs" => "AWS::Region"})
      user_data.should include({"Fn::Join" => [ ':', ['a','b','c']]})
      user_data.should include({"Fn::Select" => [ '1', ['a','b','c']]})
    end

    it "should transform bash script to CF template user_data" do
      block = Proc.new { }
      template = Lono::Template.new("foo", block)

      line = 'echo {"Ref"=>"AWS::StackName"} > /tmp/stack_name ; {"Ref"=>"Ami"}'
      data = template.transform(line)
      data.should == ["echo ", {"Ref"=>"AWS::StackName"}, " > /tmp/stack_name ; ", {"Ref"=>"Ami"}, "\n"]

      line = 'echo {"Ref"=>"AWS::StackName"} > /tmp/stack_name'
      data = template.transform(line)
      data.should == ["echo ", {"Ref"=>"AWS::StackName"}, " > /tmp/stack_name\n"]
    end

    it "task should generate cloud formation templates" do
      Lono::Task.generate(
        :project_root => @project,
        :quiet => true
      )
      raw = IO.read("#{@project}/output/prod-api-app.json")
      json = JSON.load(raw)
      json['Description'].should == "Api Stack"
      json['Mappings']['AWSRegionArch2AMI']['us-east-1']['64'].should == 'ami-123'
    end
  end

  describe "cli specs" do
    it "should generate templates" do
      out = execute("./bin/lono generate -c --project-root #{@project}")
      out.should match /Generating Cloud Formation templates/
    end
  end
end