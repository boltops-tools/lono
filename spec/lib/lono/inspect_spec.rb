describe Lono::Inspector do
  it "lono graph" do
    out = execute("exe/lono graph example --noop")
    expect(out).to include("Generating dependencies tree")
  end

  it "lono summary" do
    out = execute("exe/lono summary example")
    expect(out).to include("Summary")
  end
end

