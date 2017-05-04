require File.expand_path("../../spec_helper", __FILE__)

describe Lono do
  before(:each) do
    lono_bin = File.expand_path("../../../bin/lono", __FILE__)
    @project_root = File.expand_path("../../../tmp/lono_project", __FILE__)
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
      out = execute("./bin/lono bashify #{path}")
      expect(out).to match /bash -lexv/
    end
  end

  describe "parsing" do
    it "should transform bash script into json array with cloudformation objects" do
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

  describe "cli specs" do
    it "should generate templates" do
      out = execute("./bin/lono generate -c --project-root #{@project_root}")
      expect(out).to match /Generating CloudFormation templates/
    end
  end
end
