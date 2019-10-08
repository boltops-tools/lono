class FnBuilderContext
  include Lono::Template::Dsl::Builder::Fn
end

describe Lono::Template::Dsl::Builder::Fn do
  let(:context) { FnBuilderContext.new }
  context "methods" do
    it "ref" do
      out = context.ref("Name")
      expect(out).to eq({"Ref" => "Name"})
    end

    it "base64" do
      out = context.base64("some value")
      expect(out).to eq({"Fn::Base64" => "some value"})
    end

    it "cidr" do
      out = context.cidr("ip_block", "count", "cidr_bits")
      expect(out).to eq({"Fn::Cidr"=>["ip_block", "count", "cidr_bits"]})
    end

    it "find_in_map" do
      out = context.find_in_map("MapName", "TopLevelKey", "SecondLevelKey")
      expect(out).to eq({"Fn::FindInMap"=>["MapName", "TopLevelKey", "SecondLevelKey"]})
    end

    it "get_azs" do
      out = context.get_azs("region")
      expect(out).to eq({"Fn::GetAZs"=>"region"})
    end
  end

  context "different ways to call fn methods" do
    it "fn." do
      out = context.fn.ref("Name")
      expect(out).to eq({"Ref" => "Name"})
    end

    it "fn::" do
      out = context.fn::ref("Name")
      expect(out).to eq({"Ref" => "Name"})
    end

    it "Fn::" do
      out = Lono::Template::Dsl::Builder::Fn::ref("Name")
      expect(out).to eq({"Ref" => "Name"})
    end

    it "Fn." do
      out = Lono::Template::Dsl::Builder::Fn.ref("Name")
      expect(out).to eq({"Ref" => "Name"})
    end
  end
end
