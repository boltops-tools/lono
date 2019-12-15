class FnBuilderContext
  include Lono::Template::Strategy::Dsl::Builder::Fn
end

describe Lono::Template::Strategy::Dsl::Builder::Fn do
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
      out = Lono::Template::Strategy::Dsl::Builder::Fn::ref("Name")
      expect(out).to eq({"Ref" => "Name"})
    end

    it "Fn." do
      out = Lono::Template::Strategy::Dsl::Builder::Fn.ref("Name")
      expect(out).to eq({"Ref" => "Name"})
    end
  end

  context "bang methods allow shorter notation for ruby keyword methods" do
    it "if!" do
      out = context.if!("CreateNewSecurityGroup", context.ref("NewSecurityGroup"), context.ref("ExistingSecurityGroup"))
      expect(out).to eq({"Fn::If"=>["CreateNewSecurityGroup", {"Ref"=>"NewSecurityGroup"}, {"Ref"=>"ExistingSecurityGroup"}]})
    end

    it "and!" do
      out = context.and!(context.equals("sg-mysggroup", context.ref("ASecurityGroup")), {condition: "SomeOtherCondition"})
      expect(out).to eq({"Fn::And"=>[{"Fn::Equals"=>["sg-mysggroup", {"Ref"=>"ASecurityGroup"}]}, {:condition=>"SomeOtherCondition"}]})
    end

    it "not!" do
      out = context.not!(context.equals(context.ref("EnvironmentType"), "prod"))
      expect(out).to eq({"Fn::Not"=>[{"Fn::Equals"=>[{"Ref"=>"EnvironmentType"}, "prod"]}]})
    end

    it "or!" do
      out = context.or!(context.equals("sg-mysggroup", context.ref("ASecurityGroup")), {condition: "SomeOtherCondition"})
      expect(out).to eq({"Fn::Or"=>[{"Fn::Equals"=>["sg-mysggroup", {"Ref"=>"ASecurityGroup"}]}, {:condition=>"SomeOtherCondition"}]})
    end
  end
end
