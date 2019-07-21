require_relative "../src/timestamp_normalizer"

RSpec.describe TimestampNormalizer do

  # The Timestamp column should be formatted in ISO-8601 format.
  # The Timestamp column should be assumed to be in US/Pacific time;
  # please convert it to US/Eastern.

  # The timestamps are ambiguous -- 4/1 is April first in the US
  # but January 4 most of the rest of the world. Since we're
  # assuming the timestamps are in pacific time, I'm going to
  # assume US encoding.

  it "converts a valid timestamp without a time zone" do
    normalizer = TimestampNormalizer.new("4/1/11 11:00:00 AM")
    expect(normalizer.normalize).to eq("2011-04-01T14:00:00-04:00")
  end

  it "returns nil on mis-parse" do
    normalizer = TimestampNormalizer.new("18/1/11 11:00:00 AM")
    expect(normalizer.normalize).to eq(nil)
  end

  it "gracefully handles an empty input" do
    normalizer = TimestampNormalizer.new("")
    expect(normalizer.normalize).to be_nil
  end

  it "gracefully handles a nil input" do
    normalizer = TimestampNormalizer.new(nil)
    expect(normalizer.normalize).to be_nil
  end
end