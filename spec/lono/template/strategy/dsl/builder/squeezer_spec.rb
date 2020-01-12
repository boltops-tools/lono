describe Lono::Template::Strategy::Dsl::Builder::Squeezer do
  let(:squeezer) { Lono::Template::Strategy::Dsl::Builder::Squeezer.new(data) }
  context "with no nil values should equal initial data" do
    let(:data) do
      text =<<~EOL
        S3OriginConfig:
          OriginAccessIdentity:
            Fn::Join:
            - "/"
            - - origin-access-identity/cloudfront
              - Ref: OriginAccessIdentity
      EOL
      YAML.load(text)
    end

    it "squeeze" do
      result = squeezer.squeeze
      expect(result).to eq(data)
    end
  end

  context "nil values in Array" do
    let(:data) do
      [ :vpc, "AWS::EC2::VPC", origins: [{ cidr_block: "10.30.0.0/16", fake_property: nil }]  ]
    end

    it "squeeze" do
      result = squeezer.squeeze
      expect(result).to eq([:vpc, "AWS::EC2::VPC", {:origins=>[{:cidr_block=>"10.30.0.0/16"}]}])
    end
  end

  context "nil values in Hash" do
    let(:data) do
      { a: 1, b: nil, c: 3}
    end

    it "squeeze" do
      result = squeezer.squeeze
      expect(result).to eq({ a: 1, c: 3})
    end
  end

  context "false values in Hash" do
    let(:data) do
      { a: 1, b: false, c: 3}
    end

    it "squeeze" do
      result = squeezer.squeeze
      expect(result).to eq({ a: 1, b: false, c: 3})
    end
  end
end
