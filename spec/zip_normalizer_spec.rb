require_relative "../src/zip_normalizer"

RSpec.describe ZipNormalizer do

  # All ZIP codes should be formatted as 5 digits.
  # If there are less than 5 digits, assume 0 as the prefix.

  it "handles a normal five digit zip code" do
    normalizer = ZipNormalizer.new("12345")
    expect(normalizer.normalize).to eq("12345")
  end

  it "left pads shorter zip codes with 0" do
    normalizer = ZipNormalizer.new("123")
    expect(normalizer.normalize).to eq("00123")
  end

  it "handles an empty string" do
    normalizer = ZipNormalizer.new("")
    expect(normalizer.normalize).to eq("00000")
  end

  # this isn't in the requirements, but seems logical
  it "handles an nil string" do
    normalizer = ZipNormalizer.new(nil)
    expect(normalizer.normalize).to eq("00000")
  end

  # this isn't in the requirements, but seems logical
  it "handles a longer zip code" do
    normalizer = ZipNormalizer.new("12345-1234")
    expect(normalizer.normalize).to eq("12345-1234")
  end

end