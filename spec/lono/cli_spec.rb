describe Lono::CLI do
  it "version" do
    out = sh "exe/lono version"
    expect(out).to match /\d+/
  end
end
