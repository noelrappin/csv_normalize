require_relative "../src/full_name_normalizer"

RSpec.describe FullNameNormalizer do

  # The FullName column should be converted to uppercase.
  # There will be non-English names.

  it "handles an English name" do
    normalizer = FullNameNormalizer.new("Noel Rappin")
    expect(normalizer.normalize).to eq("NOEL RAPPIN")
  end

  it "handles a unicode name" do
    normalizer = FullNameNormalizer.new("Résumé Ron")
    expect(normalizer.normalize).to eq("RÉSUMÉ RON")
  end

  it "handles an empty string" do
    normalizer = FullNameNormalizer.new("")
    expect(normalizer.normalize).to eq("")
  end

  it "handles a nil" do
    normalizer = FullNameNormalizer.new(nil)
    expect(normalizer.normalize).to eq("")
  end

end