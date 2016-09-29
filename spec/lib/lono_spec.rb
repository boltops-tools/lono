require File.expand_path("../../spec_helper", __FILE__)

describe Lono do
  before(:each) do
    lono_bin = File.expand_path("../../../bin/lono", __FILE__)
    @project = File.expand_path("../../../tmp/lono_project", __FILE__)
    dir = File.dirname(@project)
    name = File.basename(@project)
    FileUtils.mkdir(dir) unless File.exist?(dir)
    execute("cd #{dir} && #{lono_bin} new #{name} -f -q ")
  end

  after(:each) do
    FileUtils.rm_rf(@project) unless ENV['KEEP_TMP_PROJECT']
  end

  describe "bashify" do
    it "should convert cfn user_data to bash script" do
      path = "#{$root}/spec/fixtures/cfn.json"
      out = execute("./bin/lono bashify #{path}")
      expect(out).to match /bash -lexv/
    end
  end

  describe "parsing" do
    it "should transform bash script into json array with cloud formation objects" do
      block = Proc.new { }
      template = Lono::Template.new("foo", block)

      line = '0{2345}7'
      expect(template.bracket_positions(line)).to eq [[0,0],[1,6],[7,7]]
      line = '0{2}4{6}' # more than one bracket
      expect(template.bracket_positions(line)).to eq [[0,0],[1,3],[4,4],[5,7]]
      line = '0{2}4{6{8}0}2' # nested brackets
      expect(template.bracket_positions(line)).to eq [[0,0],[1,3],[4,4],[5,11],[12,12]]

      line = '{'
      expect(template.decompose(line)).to eq ['{']

      ##########################
      line = '1{"Ref"=>"A"}{"Ref"=>"B"}'
      expect(template.decompose(line)).to eq ['1','{"Ref"=>"A"}','{"Ref"=>"B"}']

      line = '{"Ref"=>"A"}{"Ref"=>"B"}2'
      expect(template.decompose(line)).to eq ['{"Ref"=>"A"}','{"Ref"=>"B"}','2']

      line = '1{"Ref"=>"A"}{"Ref"=>"B"}2'
      expect(template.decompose(line)).to eq ['1','{"Ref"=>"A"}','{"Ref"=>"B"}','2']

      line = '{"Ref"=>"A"}{"Ref"=>"B"}'
      expect(template.decompose(line)).to eq ['{"Ref"=>"A"}','{"Ref"=>"B"}']

      line = 'Ref{"Ref"=>"B"}'
      expect(template.decompose(line)).to eq ['Ref','{"Ref"=>"B"}']
      ##############################

      # only allow whitelist
      line = 'a{b}{"foo"=>"bar"}h'
      expect(template.decompose(line)).to eq ['a{b}{"foo"=>"bar"}h']

      line = 'a{b}{"Ref"=>"bar"}h'
      expect(template.decompose(line)).to eq ['a{b}','{"Ref"=>"bar"}','h']
      line = 'a{"Ref"=>"bar"}c{"Ref"=>{"cat"=>"mouse"}}e' # nested brackets
      expect(template.decompose(line)).to eq ['a','{"Ref"=>"bar"}','c','{"Ref"=>{"cat"=>"mouse"}}','e']

      line = 'test{"Ref"=>"world"}me' # nested brackets
      decomposition = template.decompose(line)
      result = template.recompose(decomposition)
      expect(result).to eq ["test", {"Ref" => "world"}, "me"]

      line = 'test{"Ref"=>"world"}me'
      expect(template.transform(line)).to eq ["test", {"Ref" => "world"}, "me\n"]
      line = '{"Ref"=>"world"}'
      expect(template.transform(line)).to eq [{"Ref" => "world"}, "\n"]
      line = '{'
      expect(template.transform(line)).to eq ["{\n"]
      line = 'Ref{"Ref"=>"B"}'
      expect(template.transform(line)).to eq ['Ref',{"Ref"=>"B"}, "\n"]
    end
  end

  describe "ruby specs" do
    before(:each) do
      dsl = Lono::DSL.new(
        project_root: @project,
        quiet: true
      )
      dsl.run
    end

    it "should generate cloud formation template" do
      raw = IO.read("#{@project}/output/prod-api-app.json")
      json = JSON.load(raw)
      expect(json['Description']).to eq "Api Stack"
      expect(json['Mappings']['AWSRegionArch2AMI']['us-east-1']['64']).to eq 'ami-123'
    end

    it "should make trailing options pass to the partial helper available as instance variables" do
      raw = IO.read("#{@project}/output/prod-api-app.json")
      json = JSON.load(raw)
      expect(json['Resources']['HostRecord']['Properties']['Comment']).to eq 'DNS name for mydomain.com'
    end

    it "should generate user data with variables" do
      raw = IO.read("#{@project}/output/prod-api-redis.json")
      json = JSON.load(raw)
      expect(json['Description']).to eq "Api redis"
      user_data = json['Resources']['server']['Properties']['UserData']['Fn::Base64']['Fn::Join'][1]
      expect(user_data).to include("VARTEST=foo\n")
    end

    it "should include multiple user_data scripts" do
      raw = IO.read("#{@project}/output/prod-api-redis.json")
      json = JSON.load(raw)
      expect(json['Description']).to eq "Api redis"
      user_data = json['Resources']['server']['Properties']['UserData']['Fn::Base64']['Fn::Join'][1]
      expect(user_data).to include("DB2=test\n")
    end

    it "should generate db template" do
      raw = IO.read("#{@project}/output/prod-api-redis.json")
      json = JSON.load(raw)
      expect(json['Description']).to eq "Api redis"
      user_data = json['Resources']['server']['Properties']['UserData']['Fn::Base64']['Fn::Join'][1]
      expect(user_data).to include({"Ref" => "AWS::StackName"})
      expect(user_data).to include({"Ref" => "WaitHandle"})
      expect(user_data).to include({
        "Fn::FindInMap" => [
          "EnvironmentMapping",
          "HostnamePrefix",
          {"Ref" => "Environment"}
        ]
      })
      expect(user_data).to include({
        "Fn::FindInMap" => [
          "MapName",
          "TopLevelKey",
          "SecondLevelKey"
        ]
      })
      expect(user_data).to include({"Ref" => "DRINK"})

      expect(user_data).to include({"Fn::Base64" => "value to encode"})
      expect(user_data).to include({"Fn::GetAtt" => ["server", "PublicDnsName"]})
      expect(user_data).to include({"Fn::GetAZs" => "AWS::Region"})
      expect(user_data).to include({"Fn::Join" => [ ':', ['a','b','c']]})
      expect(user_data).to include({"Fn::Select" => [ '1', ['a','b','c']]})
    end

    it "should transform bash script to CF template user_data" do
      block = Proc.new { }
      template = Lono::Template.new("foo", block)

      line = 'echo {"Ref"=>"AWS::StackName"} > /tmp/stack_name ; {"Ref"=>"Ami"}'
      data = template.transform(line)
      expect(data).to eq ["echo ", {"Ref"=>"AWS::StackName"}, " > /tmp/stack_name ; ", {"Ref"=>"Ami"}, "\n"]

      line = 'echo {"Ref"=>"AWS::StackName"} > /tmp/stack_name'
      data = template.transform(line)
      expect(data).to eq ["echo ", {"Ref"=>"AWS::StackName"}, " > /tmp/stack_name\n"]

      line = 'echo {"Fn::FindInMap" => [ "A", "B", {"Ref"=>"AWS::StackName"} ]}'
      data = template.transform(line)
      expect(data).to eq ["echo ", {"Fn::FindInMap" => ["A", "B", {"Ref"=>"AWS::StackName"}]}, "\n"]

      line = 'echo {"Fn::FindInMap" => [ "A", "B", {"Ref"=>"AWS::StackName"} ]} > /tmp/stack_name ; {"Ref"=>"Ami"}'
      data = template.transform(line)
      expect(data).to eq ["echo ", {"Fn::FindInMap" => ["A", "B", {"Ref"=>"AWS::StackName"}]}, " > /tmp/stack_name ; ", {"Ref"=>"Ami"}, "\n"]
    end

    it "should not transform user_data ruby scripts" do
      raw = IO.read("#{@project}/output/prod-api-worker.json")
      json = JSON.load(raw)
      user_data = json['Resources']['LaunchConfig']['Properties']['UserData']['Fn::Base64']['Fn::Join'][1]
      expect(user_data).to include(%Q|ec2.tags.create(ec2.instances[my_instance_id], "Name", {value: Facter.hostname})\n|)
      expect(user_data).to include(%Q{find_all{ |record_set| record_set[:name] == record_name }\n})
    end

    it "should create parent folders for parent/db-stack.json" do
      directory_created = File.exist?("#{@project}/output/parent")
      expect(directory_created).to be true
    end

    it "task should generate cloud formation templates" do
      raw = IO.read("#{@project}/output/prod-api-app.json")
      json = JSON.load(raw)
      expect(json['Description']).to eq "Api Stack"
      expect(json['Mappings']['AWSRegionArch2AMI']['us-east-1']['64']).to eq 'ami-123'
    end
  end

  describe "cli specs" do
    it "should generate templates" do
      out = execute("./bin/lono generate -c --project-root #{@project}")
      expect(out).to match /Generating Cloud Formation templates/
    end
  end
end
