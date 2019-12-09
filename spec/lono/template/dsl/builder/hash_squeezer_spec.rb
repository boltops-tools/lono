describe Lono::Template::Dsl::Builder::Resource do
  let(:squeezer) { Lono::Template::Dsl::Builder::HashSqueezer.new(data) }

  context("data") do
    let(:data) do
      {
        a: 1,
        b: nil,
        c: 3,
        d: {x: 7, y: nil, z: 9}
      }
    end

    it "squeeze" do
      data = squeezer.squeeze
      expect(data).to eq({:a=>1, :c=>3, :d=>{:x=>7, :z=>9}})
    end
  end
end
