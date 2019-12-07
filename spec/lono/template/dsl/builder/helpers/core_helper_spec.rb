class CoreHelperTester
  include Lono::Template::Dsl::Builder::Helpers::CoreHelper

  def initialize
    @tags = {name: "mimic-var"}
  end
end

describe Lono::Template::Dsl::Builder::Helpers::CoreHelper do
  let(:tester) { CoreHelperTester.new }
  context "tags" do
    it "convert Hash to Array" do
      list = tester.tags(Name: "test")
      expect(list).to eq [{:Key=>"Name", :Value=>"test"}]
    end

    it "leave Array only" do
      list = tester.tags([{:Key=>"Name", :Value=>"test"}])
      expect(list).to eq [{:Key=>"Name", :Value=>"test"}]
    end

    it "leave Hash auto-camelize" do
      list = tester.tags(name: "test")
      expect(list).to eq [{:Key=>"Name", :Value=>"test"}]
    end

    it "use @tags variable to popular tags value" do
      list = tester.tags
      expect(list).to eq [{:Key=>"Name", :Value=>"mimic-var"}]
    end
  end
end
