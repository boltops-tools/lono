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

  describe "bashify" do
    it "should convert cfn user_data to bash script" do
      path = "#{$root}/spec/fixtures/cfn.json"
      out = execute("./bin/lono bashify #{path}")
      out.should match /bash -lexv/
    end
  end

  describe "parsing" do
    it "should transform bash script into json array with cloud formation objects" do
      block = Proc.new { }
      template = Lono::Template.new("foo", block)

      line = '0{2345}7'
      template.bracket_positions(line).should == [[1,6]]
      line = '0{2}4{6}' # more than one bracket
      template.bracket_positions(line).should == [[1,3],[5,7]]
      line = '0{2}4{6{8}0}2' # nested brackets
      template.bracket_positions(line).should == [[1,3],[5,11]]

      line = '0{2=>5}7'
      template.parse_positions(line).should == [1,7]
      line = '0{2=>5}4{6=>{8=>9}}2' # nested brackets
      template.parse_positions(line).should == [1, 7, 8, 19]
      line = '0{2=>5}4{' # nested brackets
      template.parse_positions(line).should == [1, 7]

      line = '{'
      template.decompose(line).should == ['{']

      line = 'a{"foo"=>"bar"}h'
      template.decompose(line).should == ['a','{"foo"=>"bar"}','h']
      line = 'a{"foo"=>"bar"}c{"dog"=>{"cat"=>"mouse"}}e' # nested brackets
      template.decompose(line).should == ['a','{"foo"=>"bar"}','c','{"dog"=>{"cat"=>"mouse"}}','e']

      line = 'test{"hello"=>"world"}me' # nested brackets
      decomposition = template.decompose(line)
      result = template.recompose(decomposition)
      result.should == ["test", {"hello" => "world"}, "me"]

      line = 'test{"hello"=>"world"}me'
      template.transform(line).should == ["test", {"hello" => "world"}, "me\n"]
      line = '{"hello"=>"world"}'
      template.transform(line).should == [{"hello" => "world"}, "\n"]
      line = '{'
      template.transform(line).should == ["{\n"]
    end
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

      line = 'echo {"Fn::FindInMap" => [ "A", "B", {"Ref"=>"AWS::StackName"} ]}'
      data = template.transform(line)
      data.should == ["echo ", {"Fn::FindInMap" => ["A", "B", {"Ref"=>"AWS::StackName"}]}, "\n"]

      line = 'echo {"Fn::FindInMap" => [ "A", "B", {"Ref"=>"AWS::StackName"} ]} > /tmp/stack_name ; {"Ref"=>"Ami"}'
      data = template.transform(line)
      data.should == ["echo ", {"Fn::FindInMap" => ["A", "B", {"Ref"=>"AWS::StackName"}]}, " > /tmp/stack_name ; ", {"Ref"=>"Ami"}, "\n"]
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