describe Lono::Cfn::Plan::Diff::Data do
  let(:data) { subject }
  it "diff" do
    a = {k1: "v1", k2: "v2", k4: "v4"}
    b = {k2: "v2changed", k3: "v3", k4: "v4"}
    data.show(a, b)
    expect(logs).to include("Added")
    expect(logs).to include("Removed")
    expect(logs).to include("Modified")
  end
end
