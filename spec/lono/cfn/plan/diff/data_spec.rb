describe Lono::Cfn::Plan::Diff::Data do
  it "diff" do
    old = {k1: "v1", k2: "v2", k4: "v4"}
    new = {k2: "v2changed", k3: "v3", k4: "v4"}
    data = described_class.new(old, new)
    data.show
    expect(logs).to include("Added")
    expect(logs).to include("Removed")
    expect(logs).to include("Modified")
  end
end
