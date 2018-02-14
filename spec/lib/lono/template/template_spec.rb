describe Lono::Template do
  let(:template) do
    block = Proc.new {}
    template = Lono::Template::Template.new("output_name.yml", block)

    # override the puts and printf methods within the test
    def template.messages
      @messages
    end

    def template.puts(msg)
      @messages ||= []
      @messages << msg
      nil
    end

    def template.printf(*args)
      @messages ||= []
      @messages << args
    end

    template
  end

  context "valid erb template" do
    it "should be able to lono generate" do
      template.erb_result("path", "template")
    end
  end

  context "invalid erb template" do
    it "should print out useful error message about undefined variable" do
      template.erb_result("path", "variable does not exist\n<% variable %>\nanother line")
      errors = template.messages.grep(/Error evaluating ERB template on line/)
      expect(errors).not_to be_empty
    end

    it "should print out useful error message about syntax error" do
      template.erb_result("path", "<%s dsfds ?%>\nanother line")
      errors = template.messages.grep(/Error evaluating ERB template on line/)
      expect(errors).not_to be_empty
    end
  end

  describe "parsing" do
    it "should transform bash script into json array with cloudformation objects" do
      block = Proc.new { }
      template = Lono::Template::Template.new("foo", block)

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

end
