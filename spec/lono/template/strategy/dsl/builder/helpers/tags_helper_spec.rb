class TagsHelperTester
  include Lono::Template::Strategy::Dsl::Builder::Helpers::TagsHelper

  def initialize
    @tags = {Name: "mimic-var"}
  end
end

describe Lono::Template::Strategy::Dsl::Builder::Helpers::TagsHelper do
  include Lono::Template::Strategy::Dsl::Builder::Fn # to test ref

  let(:tester) { TagsHelperTester.new }
  context "tags" do
    it "Hash convert to Array" do
      list = tester.tags(Name: "test")
      expect(list).to eq [{:Key=>"Name", :Value=>"test"}]
    end

    it "Array leave only" do
      list = tester.tags([{:Key=>"Name", :Value=>"test"}])
      expect(list).to eq [{:Key=>"Name", :Value=>"test"}]
    end

    it "Hash dont auto-camelize" do
      list = tester.tags(name: "test")
      expect(list).to eq [{:Key=>"name", :Value=>"test"}]
    end

    it "use @tags variable to popular tags value" do
      list = tester.tags
      expect(list).to eq [{:Key=>"Name", :Value=>"mimic-var"}]
    end

    it "Hash PropagateAtLaunch special key" do
      list = tester.tags(Name: "test", PropagateAtLaunch: true)
      expect(list).to eq [{:Key=>"Name", :Value=>"test", :PropagateAtLaunch=>true}]
    end

    it "Hash with refs" do
      list = tester.tags(Name: ref("test"))
      expect(list).to eq [{:Key=>"Name", :Value=>{"Ref"=>"Test"}}]
    end
  end
end
