require_relative "../src/row_normalizer"

RSpec.describe RowNormalizer do

  it "transforms a basic row" do
    normalizer = RowNormalizer.new(
      "4/1/11 11:00:00 AM", "123 4th St, Anywhere, AA", "94121",
      "Monkey Alberto", "1:23:32.123", "1:32:33.123", "zzsasdfa",
      "I am the very model of a modern major general")
    expect(normalizer.normalize).to eq(
      ["2011-04-01T14:00:00-04:00", "123 4th St, Anywhere, AA",
       "94121", "MONKEY ALBERTO", 5012.123, 5553.123, 10565.246,
       "I am the very model of a modern major general"])
    expect(normalizer).to be_successful
  end

  it "refuses to transform a row with a bad date" do
    normalizer = RowNormalizer.new(
      "45/34/11 11:00:00 AM", "123 4th St, Anywhere, AA", "94121",
      "Monkey Alberto", "1:23:32.123", "1:32:33.123", "zzsasdfa",
      "I am the very model of a modern major general")
    expect(normalizer.normalize).to eq(
      [nil, "123 4th St, Anywhere, AA",
       "94121", "MONKEY ALBERTO", 5012.123, 5553.123, 10565.246,
       "I am the very model of a modern major general"])
    expect(normalizer).not_to be_successful
  end

  it "transforms an empty row" do
    normalizer = RowNormalizer.new("", "", "", "", "", "", "", "")
    expect(normalizer.normalize).to eq(
      [nil, "", "00000", "", 0, 0, 0, ""])
  end

  it "transforms a bunch of nils" do
    normalizer = RowNormalizer.new(nil, nil, nil, nil, nil, nil, nil, nil)
    expect(normalizer.normalize).to eq(
      [nil, nil, "00000", "", 0, 0, 0, nil])
  end

end