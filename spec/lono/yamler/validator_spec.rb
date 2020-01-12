describe Lono::Yamler::Validator do
  subject { Lono::Yamler::Validator.new(path) }
  let(:path) { "spec/fixtures/validator/bad.yml" }
  it "validate shows exact line of error code where yaml is invalid" do
    out = subject.validate!
    expect(out).to include("2 foo")
  end
end
