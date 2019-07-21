require_relative "../src/duration_normalizer"

RSpec.describe DurationNormalizer do

  it "correctly parses a well-formatted duration" do
    normalizer = DurationNormalizer.new("1:23:32.123")
    expect(normalizer.normalize).to eq(5012.123)
  end

  it "correctly handles a duration with leading zeros" do
    normalizer = DurationNormalizer.new("0:03:02.023")
    expect(normalizer.normalize).to eq(182.023)
  end

  # the requirements don't specify error behavior here,
  # for simplicity's sake, I'm going to assume the ruby
  # to_i behavior on any segment that isn't an integer,
  # which is to say it only parses up to the point of the
  # non integer. This should also take care of non utf-8
  # characters.

  it "gracefully parses a duration with bad characters" do
    normalizer = DurationNormalizer.new("1:bb:32.123")
    expect(normalizer.normalize).to eq(3632.123)
  end

  it "gracefully parses a duration with empty characters" do
    normalizer = DurationNormalizer.new("1::32.123")
    expect(normalizer.normalize).to eq(3632.123)
  end

  it "correctly parses a duration without hours" do
    normalizer = DurationNormalizer.new("23:32.123")
    expect(normalizer.normalize).to eq(1412.123)
  end

  it "correctly parses a duration without hours or minutes" do
    normalizer = DurationNormalizer.new("32.123")
    expect(normalizer.normalize).to eq(32.123)
  end

  it "correctly parses a blank string" do
    normalizer = DurationNormalizer.new("")
    expect(normalizer.normalize).to eq(0)
  end

  it "correctly parses a nil" do
    normalizer = DurationNormalizer.new(nil)
    expect(normalizer.normalize).to eq(0)
  end

end