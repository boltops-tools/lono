require "spec_helper"

describe Lono::Template::DSL do
  before(:each) do
    ENV['TMP_LONO_ROOT'] = "tmp/lono_project" # this gets generated
    ENV['LONO_ROOT'] = "tmp/lono_project" # this gets kept
  end
  after(:each) do
    FileUtils.rm_rf(ENV['TMP_LONO_ROOT']) unless ENV['KEEP_TMP_PROJECT']
  end

  context "json starter project" do
    before(:each) do
      new_project = Lono::New.new(
        force: true,
        quiet: true,
        format: 'json',
        project_root: ENV['TMP_LONO_ROOT'],
      )
      new_project.run
    end

    it "json" do
      dsl = Lono::Template::DSL.new(
        quiet: true
      )
      dsl.evaluate_templates # run the dependent instance_eval and load_subfoler so @templates is assigned
      detected_format = dsl.detect_format
      expect(detected_format).to eq 'json'
    end
  end

  context "yaml starter project" do
    before(:each) do
      new_project = Lono::New.new(
        force: true,
        quiet: true,
        format: 'yaml',
        project_root: ENV['TMP_LONO_ROOT'],
      )
      new_project.run
    end

    it "yaml" do
      dsl = Lono::Template::DSL.new(
        quiet: true
      )
      dsl.evaluate_templates # run the dependent instance_eval and load_subfoler so @templates is assigned
      detected_format = dsl.detect_format
      expect(detected_format).to eq 'yml'
    end
  end

  context "multiple format starter project" do
    # it "yaml" do
    #   dsl = Lono::Template::DSL.new(
    #     project_root: @project,
    #     quiet: true
    #   )
    #   detected_format = dsl.detect_format
    #   expect(detected_format).to eq 'yaml'
    # end
  end

  context "json starter project" do
    before(:each) do
      new_project = Lono::New.new(
        force: true,
        quiet: true,
        format: 'json',
        project_root: ENV['TMP_LONO_ROOT'],
      )
      new_project.run

      dsl = Lono::Template::DSL.new(
        quiet: true
      )
      dsl.run
    end

    it "should generate cloudformation template" do
      raw = IO.read("#{Lono.root}/output/api-web.json")
      json = JSON.load(raw)
      expect(json['Description']).to eq "Api Stack"
      expect(json['Mappings']['AWSRegionArch2AMI']['us-east-1']['64']).to eq 'ami-123'
    end

    it "should make trailing options pass to the partial helper available as instance variables" do
      puts "Lono.root #{Lono.root}"
      raw = IO.read("#{Lono.root}/output/api-web.json")
      json = JSON.load(raw)
      expect(json['Resources']['HostRecord']['Properties']['Comment']).to eq 'DNS name for mydomain.com'
    end

    it "should generate user data with variables" do
      raw = IO.read("#{Lono.root}/output/api-redis.json")
      json = JSON.load(raw)
      expect(json['Description']).to eq "Api redis"
      user_data = json['Resources']['server']['Properties']['UserData']['Fn::Base64']['Fn::Join'][1]
      expect(user_data).to include("VARTEST=foo\n")
    end

    it "should include multiple user_data scripts" do
      raw = IO.read("#{Lono.root}/output/api-redis.json")
      json = JSON.load(raw)
      expect(json['Description']).to eq "Api redis"
      user_data = json['Resources']['server']['Properties']['UserData']['Fn::Base64']['Fn::Join'][1]
      expect(user_data).to include("DB2=test\n")
    end

    it "should generate db template" do
      raw = IO.read("#{Lono.root}/output/api-redis.json")
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
      template = Lono::Template::Template.new("foo", block)

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
      raw = IO.read("#{Lono.root}/output/api-worker.json")
      json = JSON.load(raw)
      user_data = json['Resources']['LaunchConfig']['Properties']['UserData']['Fn::Base64']['Fn::Join'][1]
      expect(user_data).to include(%Q|ec2.tags.create(ec2.instances[my_instance_id], "Name", {value: Facter.hostname})\n|)
      expect(user_data).to include(%Q{find_all{ |record_set| record_set[:name] == record_name }\n})
    end

    it "should create parent folders for parent/db-stack.json" do
      directory_created = File.exist?("#{Lono.root}/output/parent")
      expect(directory_created).to be true
    end

    it "task should generate CloudFormation templates" do
      raw = IO.read("#{Lono.root}/output/api-web.json")
      json = JSON.load(raw)
      expect(json['Description']).to eq "Api Stack"
      expect(json['Mappings']['AWSRegionArch2AMI']['us-east-1']['64']).to eq 'ami-123'
    end
  end

end
